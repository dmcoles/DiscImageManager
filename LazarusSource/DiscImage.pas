unit DiscImage;

{
TDiscImage class V1.38.5
Manages retro disc images, presenting a list of files and directories to the
parent application. Will also extract files and write new files. Almost a complete
filing system in itself. Compatible with Acorn DFS, Acorn ADFS, UEF, Commodore
1541, Commodore 1571, Commodore 1581, and Commodore AmigaDOS.

Copyright (C) 2018-2022 Gerald Holdsworth gerald@hollypops.co.uk

This source is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public Licence as published by the Free
Software Foundation; either version 3 of the Licence, or (at your option)
any later version.

This code is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.  See the GNU General Public Licence for more
details.

A copy of the GNU General Public Licence is available on the World Wide Web
at <http://www.gnu.org/copyleft/gpl.html>. You can also obtain it by writing
to the Free Software Foundation, Inc., 51 Franklin Street - Fifth Floor,
Boston, MA 02110-1335, USA.
}

{$MODE objFPC}{$H+}

interface

uses Classes,DiscImageUtils,Math,crc,ZStream,StrUtils,Spark;

{$M+}

//The class definition
type
 TDiscImage    = Class
 private
  type
  //Free space map
  TTrack = array of TDIByteArray; //TDIByteArray representing the sectors
  TSide  = array of TTrack;       //Sides
  //Directories
  TDir          = record
   Directory,                       //Directory name (ALL)
   Title       : String;            //Directory title (DFS/ADFS)
   Entries     : array of TDirEntry;//Entries (above)
   ErrorCode   : Byte;              //Used to indicate error for broken directory (ADFS)
   Broken,                          //Flag if directory is broken (ADFS)
   Locked,                          //Flag if disc is locked (MMFS)
   DOSPartition,                    //Is this in the DOS Plus partition? (ADFS/DOS Plus)
   AFSPartition: Boolean;           //Is this in the AFS partition? (ADFS/AFS)
   Sector,                          //Where is this directory located (same as TDirEntry)
   Partition   : Cardinal;          //Which partition (side) is this on?
   Parent      : Integer;           //What is the TDir reference of the parent (-1 if none)
  end;
  //Collection of directories
  TDisc         = array of TDir;
  //Fragment
  TFragment     = record        //For retrieving the ADFS E/F fragment information
   Offset,
   Length,
   Zone         : Cardinal;
  end;
  //To collate fragments (ADFS/CDR/Amiga/AFS)
  TFragmentArray= array of TFragment;
  //Provides feedback
  TProgressProc = procedure(Fupdate: String) of Object;
 private
  FDisc         : TDisc;        //Container for the entire catalogue
  Fdata         : TDIByteArray; //Container for the image to be loaded into
  FDSD,                         //Double sided flag (Acorn DFS)
  FMap,                         //Old/New Map flag (Acorn ADFS) OFS/FFS (Amiga)
  FBootBlock,                   //Is disc an AmigaDOS Kickstart?
  Fupdating,                    //Has BeginUpdate been called?
  FAFSPresent,                  //Is there an AFS partition present? (ADFS)
  FDOSPresent,                  //Is there a DOS Plus partition present? (ADFS)
  FSparkAsFS,                   //Deal with Spark archives as a filing system
  FDFSzerosecs,                 //Allow zero length disc images for DFS?
  FDFSAllowBlank,               //Allow blank filenames
  FDFSBeyondEdge: Boolean;      //Check for files going beyond the DFS disc edge
  secsize,                      //Sector Size
  bpmb,                         //Bits Per Map Bit (Acorn ADFS New)
  dosalloc,                     //Allocation Unit (DOS Plus)
  nzones,                       //Number of zones (Acorn ADFS New)
  root,                         //Root address (not fragment)
  rootfrag,                     //Root indirect address (Acorn ADFS New)
  Fafsroot,                     //Root address of the AFS root partition
  Fdosroot,                     //Root address of the DOS Plus root partition
  afshead,                      //Address of the AFS header             
  afshead2,                     //Address of the AFS header copy
  doshead,                      //Address of the DOS Plus header, if exists
  dosmap,                       //Address of the DOS Plus FAT
  dosmap2,                      //Address of the second DOS Plus FAT (if applicable)
  bootmap,                      //Offset of the map (Acorn ADFS)
  zone_spare,                   //Spare bits between zones (Acorn ADFS New)
  format_vers,                  //Format version (Acorn ADFS New)
  root_size,                    //Size of the root directory (Acorn ADFS New)
  afsroot_size,                 //Size of the AFS Root directory
  dosroot_size,                 //Size of the DOS Plus Root directory
  cluster_size,                 //Size of a DOS cluster
  DOSBlocks,                    //Size of a DOS partition in blocks
  disc_id,                      //Disc ID (Acorn ADFS)
  emuheader,                    //Allow for any headers added by emulators
  namesize,                     //Size of the name area (Acorn ADFS Big Dir)
  brokendircount,               //Number of broken directories (ADFS)
  FMaxDirEnt    : Cardinal;     //Maximum number of directory entries in image
  DOSFATSize,                   //Size of DOS Plus FAT in blocks
  FFormat       : Word;         //Format of the image
  FForceInter,                  //What to do about ADFS L/AFS Interleaving
  Finterleave,                  //Interleave method (1=seq,2=int,3=mux)
  secspertrack,                 //Number of sectors per track
  heads,                        //Number of heads (Acorn ADFS New)
  density,                      //Density (Acorn ADFS New)
  idlen,                        //Length of fragment ID in bits (Acorn ADFS New)
  skew,                         //Head skew (Acorn ADFS New)
  lowsector,                    //Lowest sector number (Acorn ADFS New)
  disctype,                     //Type of disc
  FDirType,                     //Directory Type (Acorn ADFS)
  share_size,                   //Share size (Acorn ADFS New)
  big_flag,                     //Big flag (Acorn ADFS New)
  FATType,                      //FAT Type - 12: FAT12, 16: FAT16, 32: FAT32
  NumFATs       : Byte;         //Number of FATs in a DOS Plus image
  root_name,                    //Root title
  dosrootname,                  //DOS Plus root name
  imagefilename,                //Filename of the disc image
  FFilename     : String;       //Copy of above, but doesn't get wiped
  dir_sep       : Char;         //Directory Separator
  free_space_map: TSide;        //Free Space Map
  disc_size,                    //Disc size per partition
  free_space    : array of Int64;//Free space per partition
  disc_name     : array of String;//Disc title(s)
  bootoption    : TDIByteArray; //Boot Option(s)
  CFSFiles      : array of TDIByteArray;//All the data for the CFS files
  FProgress     : TProgressProc;//Used for feedback
  SparkFile     : TSpark;       //For reading in Spark archives
  //Private methods
  procedure ResetVariables;
  function ReadString(ptr,term: Integer;control: Boolean=True): String;
  function ReadString(ptr,term: Integer;var buffer: TDIByteArray;
                                      control: Boolean=True): String; overload;
  procedure WriteString(str: String;ptr,len: Cardinal;pad: Byte);
  procedure WriteString(str: String;ptr,len: Cardinal;pad: Byte;
                                            var buffer: TDIByteArray); overload;
  function FormatToString: String;
  function FormatToExt: String;
  function ReadBits(offset,start,length: Cardinal): Cardinal;
  procedure WriteBits(value,offset,start,length: Cardinal);
  procedure WriteBits(value,offset,start,length: Cardinal;buffer: TDIByteArray); overload;
  function RISCOSToTimeDate(filedatetime: Int64): TDateTime;
  function TimeDateToRISCOS(delphitime: TDateTime): Int64;
  function Read32b(offset: Cardinal; bigendian: Boolean=False): Cardinal;
  function Read32b(offset: Cardinal; var buffer: TDIByteArray;
                                      bigendian: Boolean=False): Cardinal; overload;
  function Read24b(offset: Cardinal; bigendian: Boolean=False): Cardinal;
  function Read24b(offset: Cardinal; var buffer: TDIByteArray;
                                      bigendian: Boolean=False): Cardinal; overload;
  function Read16b(offset: Cardinal; bigendian: Boolean=False): Word;
  function Read16b(offset: Cardinal; var buffer: TDIByteArray;
                                      bigendian: Boolean=False): Word; overload;
  function ReadByte(offset: Cardinal): Byte;
  function ReadByte(offset: Cardinal; var buffer: TDIByteArray): Byte; overload;
  function DiscAddrToIntOffset(disc_addr: Cardinal): Cardinal;
  procedure Write32b(value, offset: Cardinal; bigendian: Boolean=False); 
  procedure Write32b(value, offset: Cardinal; var buffer: TDIByteArray;
                                      bigendian: Boolean=False); overload;
  procedure Write24b(value, offset: Cardinal; bigendian: Boolean=False);
  procedure Write24b(value, offset: Cardinal; var buffer: TDIByteArray;
                                      bigendian: Boolean=False); overload;
  procedure Write16b(value: Word; offset: Cardinal; bigendian: Boolean=False);
  procedure Write16b(value: Word; offset: Cardinal; var buffer: TDIByteArray;
                                      bigendian: Boolean=False); overload;
  procedure WriteByte(value: Byte; offset: Cardinal);
  procedure WriteByte(value: Byte; offset: Cardinal; var buffer: TDIByteArray); overload;
  function GetDataLength: Cardinal;
  procedure SetDataLength(newlen: Cardinal);
  function ROR13(v: Cardinal): Cardinal;
  procedure ResetDir(var Entry: TDir);
  function MapFlagToByte: Byte;
  function MapTypeToString: String;
  function DirTypeToString: String;
  function GeneralChecksum(offset,length,chkloc,start: Cardinal;carry: Boolean): Cardinal;
  function GetImageCrc: String;
  function GetCRC(var buffer: TDIByteArray): String;
  function GetCRC16(start,len: Cardinal;var buffer: TDIByteArray): Cardinal;
  procedure UpdateProgress(Fupdate: String);
  function GetRootAddress: Cardinal;
  function Inflate(filename: String): TDIByteArray;
  function InterleaveString: String;
  //ADFS Routines
  function ID_ADFS: Boolean;
  function ReadADFSDir(dirname: String; sector: Cardinal): TDir;
  function CalculateADFSDirCheck(sector: Cardinal): Byte;
  function CalculateADFSDirCheck(sector: Cardinal;buffer:TDIByteArray): Byte; overload;
  function NewDiscAddrToOffset(addr: Cardinal;offset:Boolean=True): TFragmentArray;
  function OffsetToOldDiscAddr(offset: Cardinal): Cardinal;
  function ByteChecksum(offset,size: Cardinal): Byte;      
  function ByteChecksum(offset,size: Cardinal;var buffer: TDIByteArray): Byte; overload;
  function ReadADFSDisc: TDisc;
  procedure ADFSFreeSpaceMap;
  procedure ADFSFillFreeSpaceMap(address: Cardinal;usage: Byte);
  function FormatADFSFloppy(minor: Byte): TDisc;
  procedure FormatOldMapADFS(disctitle: String);
  procedure FormatNewMapADFS(disctitle: String);
  function FormatADFSHDD(harddrivesize:Cardinal;newmap:Boolean;dirtype:Byte):TDisc;
  function UpdateADFSDiscTitle(title: String): Boolean;
  function UpdateADFSBootOption(option: Byte): Boolean;
  function ADFSGetFreeFragments(offset:Boolean=True): TFragmentArray;
  function WriteADFSFile(var file_details: TDirEntry;var buffer: TDIByteArray;
                         extend:Boolean=True): Integer;
  function ADFSFindFreeSpace(filelen: Cardinal;var fragid: Cardinal): TFragmentArray;
  function WriteFragmentedData(fragments: TFragmentArray;
                                            var buffer: TDIByteArray): Boolean;
  procedure ADFSAllocateFreeSpace(filelen,freeptr: Cardinal);
  procedure ADFSAllocateFreeSpace(filelen,fragid: Cardinal;fragments: TFragmentArray); overload;
  function ADFSSectorAlignLength(filelen: Cardinal): Cardinal;
  procedure ADFSCalcFileDate(var Entry: TDirEntry);
  function CreateADFSDirectory(var dirname,parent,attributes: String): Integer;
  procedure UpdateADFSCat(directory: String;newname: String='');
  function UpdateADFSFileAttributes(filename,attributes: String): Boolean;
  function ValidateADFSFilename(filename: String): String;
  function RetitleADFSDirectory(filename,newtitle: String): Boolean;
  function RenameADFSFile(oldfilename: String;var newfilename: String):Integer;
  procedure ConsolodateADFSFreeSpaceMap;
  procedure ConsolodateADFSFragments(fragid: Cardinal);
  function DeleteADFSFile(filename: String;
                         TreatAsFile:Boolean=False;extend:Boolean=True):Boolean;
  procedure ADFSDeAllocateFreeSpace(addr,len: Cardinal);
  procedure ADFSDeAllocateFreeSpace(addr: Cardinal); overload;
  function ExtractADFSFile(filename: String;var buffer: TDIByteArray): Boolean;
  function ExtractFragmentedData(fragments: TFragmentArray;
                            filelen: Cardinal;var buffer: TDIByteArray):Boolean;
  function MoveADFSFile(filename,directory: String): Integer;
  function ExtendADFSBigDir(dir: Cardinal;space: Integer;add: Boolean):Boolean;
  function ADFSBigDirSizeChange(dir,entry:Cardinal;extend:Boolean): Boolean;
  function ExtendADFSCat(dir: Cardinal;direntry: TDirEntry): Cardinal;
  procedure ReduceADFSCat(dir,entry: Cardinal);
  function FixBrokenADFSDirectories: Boolean;
  function FixADFSDirectory(dir,entry: Integer):Boolean;
  function ADFSGetHardDriveParams(Ldiscsize:Cardinal;bigmap:Boolean;
              var Lidlen,Lzone_spare,Lnzones,Llog2bpmb,Lroot: Cardinal):Boolean;
  function UpdateADFSFileAddr(filename:String;newaddr:Cardinal;load:Boolean):Boolean;
  function UpdateADFSFileType(filename:String;newtype:String):Boolean;
  function UpdateADFSTimeStamp(filename:String;newtimedate:TDateTime):Boolean;
  function ExtractADFSPartition(side: Cardinal): TDIByteArray;
  function GetADFSMaxLength(lastentry:Boolean): Cardinal;
  //Acorn FileStore Routines
  function ID_AFS: Boolean;
  procedure ReadAFSPartition;
  function ReadAFSDirectory(dirname:String;addr: Cardinal):TDir;
  function ExtractAFSFile(filename: String;var buffer: TDIByteArray): Boolean;
  function ReadAFSObject(offset: Cardinal): TDIByteArray;
  function GetAFSObjLength(offset: Cardinal): Cardinal;
  function GetAllocationMap: Cardinal;
  function GetAllocationMap(sector:Cardinal;var spt:Cardinal):Cardinal; overload;
  procedure ReadAFSFSM;
  function AFSGetFreeSectors(used: Boolean=False): TFragmentArray;
  function AFSAllocateFreeSpace(size :Cardinal;
                 var fragments: TFragmentArray;addheader:Boolean=True): Cardinal;
  procedure AFSDeAllocateFreeSpace(addr: Cardinal);
  procedure FinaliseAFSL2Map;
  function FormatAFS(harddrivesize: Cardinal;afslevel: Byte): Boolean;
  procedure WriteAFSPartition(afsdisctitle: String;harddrivesize: Cardinal);
  function CreateAFSDirectory(dirname,parent,attributes: String): Integer;
  function ExtendAFSDirectory(sector: Cardinal):Cardinal;
  function CreateAFSPassword(Accounts: TUserAccounts): Integer;
  function ReadAFSPassword: TUserAccounts;
  function WriteAFSFile(var file_details: TDirEntry;
                                              var buffer: TDIByteArray):Integer;
  function AFSAttrToByte(attr: String):Byte;
  procedure WriteAFSObject(offset: Cardinal;var buffer: TDIByteArray);
  function RenameAFSFile(oldname:String;var newname: String): Integer;
  procedure UpdateAFSDirectory(dirname: String);
  function ValidateAFSFilename(filename: String): String;
  function DeleteAFSFile(filename: String): Boolean;
  function RemoveAFSEntry(dir,entry: Cardinal): Boolean;
  function InsertAFSEntry(dir: Cardinal;file_details:TDirEntry): Integer;
  function MoveAFSFile(filename,directory: String): Integer;
  function UpdateAFSFileAddr(filename:String;newaddr:Cardinal;load:Boolean):Boolean;
  function UpdateAFSTimeStamp(filename:String;newtimedate:TDateTime):Boolean;
  function AFSTimeToWord(timedate: TDateTime):Word;
  function UpdateAFSAttributes(filename,attributes: String): Boolean;
  function UpdateAFSDiscTitle(title: String): Boolean;
  function AddAFSPartition(size: Cardinal): Boolean;
  //DFS Routines
  function ID_DFS: Boolean;
  function ReadDFSDisc(mmbdisc:Integer=-1): TDisc;
  procedure DFSFreeSpaceMap(LDisc: TDisc);
  function ConvertDFSSector(address,side: Integer): Integer;
  function WriteDFSFile(var file_details: TDirEntry;var buffer: TDIByteArray): Integer;
  procedure UpdateDFSCat(side: Integer);
  function ValidateDFSFilename(filename: String): String;
  function RenameDFSFile(oldfilename: String;var newfilename: String):Integer;
  function DeleteDFSFile(filename: String):Boolean;
  function UpdateDFSFileAttributes(filename,attributes: String): Boolean;
  function FormatDFS(minor,tracks: Byte): TDisc;
  function UpdateDFSDiscTitle(title: String;side: Byte): Boolean;
  function UpdateDFSBootOption(option,side: Byte): Boolean;
  function ExtractDFSFile(filename: String;var buffer: TDIByteArray): Boolean;
  function UpdateDFSFileAddr(filename:String;newaddr:Cardinal;load:Boolean):Boolean;
  function ExtractDFSPartition(side: Cardinal): TDIByteArray;
  function AddDFSSide(var buffer: TDIByteArray): Boolean;
  function AddDFSSide(filename: String): Boolean; overload;
  function MoveDFSFile(filename,directory: String): Integer;
  //Commodore 1541/1571/1581 Routines
  function ID_CDR: Boolean;
  function ConvertDxxTS(format,track,sector: Integer): Integer;
  function ReadCDRDisc: TDisc;
  function FormatCDR(minor: Byte): TDisc;
  procedure CDRFreeSpaceMap;
  procedure CDRSetClearBAM(track,sector: Byte;used: Boolean);
  function UpdateCDRDiscTitle(title: String): Boolean;
  function ExtractCDRFile(filename:String;var buffer:TDIByteArray): Boolean;
  function WriteCDRFile(file_details: TDirEntry;var buffer: TDIByteArray): Integer;
  procedure UpdateCDRCat;
  function CDRFindNextSector(var track,sector: Byte): Boolean;
  function CDRFindNextTrack(var track,sector: Byte): Boolean;
  function RenameCDRFile(oldfilename: String;var newfilename: String):Integer;
  function DeleteCDRFile(filename: String):Boolean;
  function UpdateCDRFileAttributes(filename,attributes: String): Boolean;
  //Sinclair Spectrum +3/Amstrad Routines
  function ID_Sinclair: Boolean;
  function ReadSinclairDisc: TDisc;
  function FormatSpectrum(minor: Byte): TDisc;
  function WriteSpectrumFile(file_details: TDirEntry;var buffer: TDIByteArray): Integer;
  function RenameSpectrumFile(oldfilename: String;var newfilename: String):Integer;
  function DeleteSinclairFile(filename: String):Boolean;
  function UpdateSinclairFileAttributes(filename,attributes: String): Boolean;
  function UpdateSinclairDiscTitle(title: String): Boolean;
  function ExtractSpectrumFile(filename:String;var buffer:TDIByteArray):Boolean;
  //Commodore Amiga Routines
  function ID_Amiga: Boolean;
  function ReadAmigaDisc: TDisc;
  function ReadAmigaDir(dirname: String; offset: Cardinal): TDir;
  function AmigaBootChecksum(offset: Cardinal): Cardinal;
  function AmigaChecksum(offset: Cardinal): Cardinal;
  function ExtractAmigaFile(filename:String;var buffer:TDIByteArray):Boolean;
  function FormatAmiga(minor: Byte): TDisc;
  function WriteAmigaFile(var file_details: TDirEntry;var buffer: TDIByteArray): Integer;
  function CreateAmigaDirectory(var dirname,parent,attributes: String): Integer;
  function RetitleAmigaDirectory(filename, newtitle: String): Boolean;
  function RenameAmigaFile(oldfilename: String;var newfilename: String):Integer;
  function DeleteAmigaFile(filename: String):Boolean;
  function UpdateAmigaFileAttributes(filename,attributes: String): Boolean;
  function UpdateAmigaDiscTitle(title: String): Boolean;
  function MoveAmigaFile(filename,directory: String): Integer;
  //Acorn CFS Routines
  function ID_CFS: Boolean;
  function ReadUEFFile: TDisc;
  function CFSBlockStatus(status: Byte): String;
  function CFSTargetMachine(machine: Byte): String;
  function ExtractCFSFile(entry: Integer;var buffer:TDIByteArray):Boolean;
  procedure WriteUEFFile(filename: String;uncompress: Boolean=False);
  function FormatCFS:TDisc;
  function DeleteCFSFile(entry: Cardinal): Boolean;
  function UpdateCFSAttributes(entry: Cardinal;attributes:String): Boolean;
  function MoveCFSFile(entry: Cardinal;dest: Integer): Integer;
  function CopyCFSFile(entry: Cardinal;dest: Integer): Integer;
  function WriteCFSFile(var file_details: TDirEntry;var buffer: TDIByteArray): Integer;
  function RenameCFSFile(entry: Cardinal;newfilename: String): Integer;
  function UpdateCFSFileAddr(entry,newaddr:Cardinal;load:Boolean):Boolean;
  //MMFS Routines
  function ID_MMB: Boolean;
  function ReadMMBDisc: TDisc;
  //Spark Routines
  function ID_Spark: Boolean;
  function ReadSparkArchive: TDisc;
  function ExtractSparkFile(filename: String;var buffer: TDIByteArray): Boolean;
  //DOS Plus Routines
  function ID_DOSPlus: Boolean;
  function IDDOSPartition(ctr: Cardinal): Boolean;
  procedure ReadDOSPartition;
  procedure ReadDOSHeader;
  function ReadDOSDirectory(dirname:String;addr:Cardinal;var len:Cardinal):TDir;
  function DOSExtToFileType(ext: String): String;
  function ConvertDOSTimeDate(time,date: Word): TDateTime;
  function DOSTime(time: TDateTime): Word;
  function DOSDate(date: TDateTime): Word;
  function ConvertDOSAttributes(attr: Byte): String;
  function ConvertDOSAttributes(attr: String): Byte; overload;
  function DOSClusterToOffset(cluster: Cardinal): Cardinal;
  function GetClusterEntry(cluster: Cardinal): Cardinal;
  procedure SetClusterEntry(cluster,entry: Cardinal);
  function IsClusterValid(cluster: Cardinal): Boolean;
  function GetClusterChain(cluster:Cardinal;len:Cardinal=0):TFragmentArray;
  procedure SetClusterChain(fragments: TFragmentArray);
  function ExtractDOSFile(filename: String;var buffer: TDIByteArray): Boolean;
  function ReadDOSObject(cluster: Cardinal;len: Cardinal=0): TDIByteArray;
  procedure ReadDOSFSM;
  function DOSGetFreeSectors(used: Boolean=False): TFragmentArray;
  function RenameDOSFile(oldname:String;var newname: String): Integer;
  function ValidateDOSFilename(filename: String): String;
  procedure UpdateDOSDirectory(dirname: String);
  procedure AllocateDOSClusters(len:Cardinal;var fragments:TFragmentArray);
  procedure DeAllocateDOSClusters(len:Cardinal;var fragments:TFragmentArray);
  function WriteDOSObject(buffer:TDIByteArray;fragments:TFragmentArray):Boolean;
  function WriteDOSFile(var file_details: TDirEntry;
                                              var buffer: TDIByteArray):Integer;
  function CreateDOSDirectory(dirname,parent,attributes: String): Integer;
  function DeleteDOSFile(filename: String): Boolean;
  function UpdateDOSAttributes(filename,attributes: String): Boolean;
  function UpdateDOSDiscTitle(title: String): Boolean;
  function UpdateDOSTimeStamp(filename:String;newtimedate:TDateTime):Boolean;
  function AddDOSPartition(size: Cardinal): Boolean;
  function FormatDOS(shape: Byte): TDisc;
  procedure WriteDOSPartition;
  procedure WriteDOSHeader;
  function MoveDOSFile(filename,directory: String): Integer;
  //Private constants
  const
   //When the change of number of sectors occurs on Commodore 1541/1571 discs
   CDRhightrack : array[0..8] of Integer = (71,66,60,53,36,31,25,18, 1);
   //Number of sectors per track (Commodore 1541/1571)
   CDRnumsects  : array[0..7] of Integer = (17,18,19,21,17,18,19,21);
   //Commodore 64 Filetypes
   CDRFileTypes : array[0.. 5] of String = (
                                   'DELDeleted'  ,'SEQSequence' ,'PRGProgram'  ,
                                   'USRUser File','RELRelative' ,'CBMCBM'      );
   //Disc title for new images
   disctitle    = 'DiscImgMgr';
   afsdisctitle = 'DiscImageManager'; //AFS has longer titles
   //Root name to use when AFS is partition on ADFS
   afsrootname  = ':AFS$';
   {$INCLUDE 'DiscImageRISCOSFileTypes.pas'}
   {$INCLUDE 'DiscImageDOSFileTypes.pas'}
 published
  //Published methods
  constructor Create;
  constructor Create(Clone: TDiscImage); overload;
  function LoadFromFile(filename: String;readdisc: Boolean=True): Boolean;
  function IDImage: Boolean;
  procedure ReadImage;
  procedure SaveToFile(filename: String;uncompress: Boolean=False);
  procedure Close;
  function FormatFDD(major,minor,tracks: Byte): Boolean;
  function FormatHDD(major:Byte;harddrivesize:Cardinal;newmap:Boolean;dirtype:Byte):Boolean;
  function ExtractFile(filename:String;var buffer:TDIByteArray;entry:Cardinal=0): Boolean;
  function WriteFile(var file_details: TDirEntry; var buffer: TDIByteArray): Integer;
  function FileExists(filename: String;var Ref: Cardinal): Boolean;
  function FileExists(filename: String;var dir,entry: Cardinal): Boolean; overload;
  function ReadDiscData(addr,count,side,offset: Cardinal;
                                             var buffer: TDIByteArray): Boolean;
  function WriteDiscData(addr,side: Cardinal;var buffer: TDIByteArray;
                                    count: Cardinal;start: Cardinal=0): Boolean;
  function FileSearch(search: TDirEntry): TSearchResults;
  function RenameFile(oldfilename: String;var newfilename: String;entry: Cardinal=0): Integer;
  function DeleteFile(filename: String;entry: Cardinal=0): Boolean;
  function MoveFile(filename,directory: String): Integer;
  function MoveFile(source: Cardinal;dest: Integer): Integer; overload;
  function CopyFile(filename,directory: String): Integer;
  function CopyFile(filename,directory,newfilename: String): Integer; overload;
  function CopyFile(source: Cardinal;dest: Integer): Integer; overload;
  function UpdateAttributes(filename,attributes: String;entry:Cardinal=0): Boolean;
  function UpdateDiscTitle(title: String;side: Byte): Boolean;
  function UpdateBootOption(option,side: Byte): Boolean;
  function CreateDirectory(var filename,parent,attributes: String): Integer;
  function RetitleDirectory(var filename,newtitle: String): Boolean;
  function GetFileCRC(filename: String;entry:Cardinal=0): String;
  function FixDirectories: Boolean;
  function SaveFilter(var FilterIndex: Integer;thisformat: Integer=-1):String;
  function UpdateLoadAddr(filename:String;newaddr:Cardinal;entry:Cardinal=0): Boolean;
  function UpdateExecAddr(filename:String;newaddr:Cardinal;entry:Cardinal=0): Boolean;
  function TimeStampFile(filename: String;newtimedate: TDateTime): Boolean;
  function ChangeFileType(filename,newtype: String): Boolean;
  function GetFileTypeFromNumber(filetype: Integer): String;
  function GetFileTypeFromName(filetype: String): Integer;
  procedure BeginUpdate;
  procedure EndUpdate;
  function ValidateFilename(parent:String;var filename:String): Boolean;
  function DiscSize(partition: Cardinal):Int64;
  function FreeSpace(partition: Cardinal):Int64;
  function Title(partition: Cardinal):String;
  function CreatePasswordFile(Accounts: TUserAccounts): Integer;
  function ReadPasswordFile: TUserAccounts;
  function GetParent(dir: Integer): String;
  function SeparatePartition(side: Cardinal;filename: String=''): Boolean;
  function GetMaxLength: Cardinal;
  function AddPartition(size: Cardinal;format: Byte): Boolean;
  function AddPartition(filename: String): Boolean; overload;
  function ChangeInterleaveMethod(NewMethod: Byte): Boolean;
  function GetDirSep(partition: Byte): Char;
  //Published properties
  property AFSPresent:          Boolean       read FAFSPresent;
  property AFSRoot:             Cardinal      read Fafsroot;
  property AllowDFSZeroSectors: Boolean       read FDFSzerosecs write FDFSzerosecs;
  property DFSBeyondEdge:       Boolean       read FDFSBeyondEdge write FDFSBeyondEdge;
  property DFSAllowBlanks:      Boolean       read FDFSAllowBlank write FDFSAllowBlank;
  property BootOpt:             TDIByteArray  read bootoption;
  property CRC32:               String        read GetImageCrc;
  property DirectoryType:       Byte          read FDirType;
  property DirectoryTypeString: String        read DirTypeToString;
  property DirSep:              Char          read dir_sep;
  property Disc:                TDisc         read FDisc;
  property DOSPlusRoot:         Cardinal      read Fdosroot;
  property DOSPresent:          Boolean       read FDOSPresent;
  property DoubleSided:         Boolean       read FDSD;
  property Filename:            String        read imagefilename write imagefilename;
  property FormatExt:           String        read FormatToExt;
  property FormatNumber:        Word          read FFormat;
  property FormatString:        String        read FormatToString;
  property FreeSpaceMap:        TSide         read free_space_map;
  property InterleaveInUse:     String        read InterleaveString;
  property InterleaveInUseNum:  Byte          read FInterleave;
  property InterleaveMethod:    Byte          read FForceInter write FForceInter;
  property MapType:             Byte          read MapFlagToByte;
  property MapTypeString:       String        read MapTypeToString;
  property MaxDirectoryEntries: Cardinal      read FMaxDirEnt;
  property ProgressIndicator:   TProgressProc write FProgress;
  property RAWData:             TDIByteArray  read Fdata;
  property RootAddress:         Cardinal      read GetRootAddress;
  property SparkAsFS:           Boolean       read FSparkAsFS write FSparkAsFS;
 public
  destructor Destroy; override;
 End;

implementation

uses
 SysUtils,DateUtils;

{$INCLUDE 'DiscImage_Private.pas'}  //Module for private methods
{$INCLUDE 'DiscImage_Published.pas'}//Module for published methods
{$INCLUDE 'DiscImage_ADFS.pas'}     //Module for Acorn ADFS
{$INCLUDE 'DiscImage_AFS.pas'}      //Module for Acorn File Server
{$INCLUDE 'DiscImage_DFS.pas'}      //Module for Acorn/Watford DFS
{$INCLUDE 'DiscImage_C64.pas'}      //Module for Commodore 1541/1571/1581
{$INCLUDE 'DiscImage_Spectrum.pas'} //Module for Spectrum +3/Amstrad DSK
{$INCLUDE 'DiscImage_Amiga.pas'}    //Module for Commodore AmigaDOS
{$INCLUDE 'DiscImage_CFS.pas'}      //Module for Acorn Cassette Filing System (UEF)
{$INCLUDE 'DiscImage_MMB.pas'}      //Module for MMFS - to be removed
{$INCLUDE 'DiscImage_Spark.pas'}    //Module for SparkFS
{$INCLUDE 'DiscImage_DOSPlus.pas'}  //Module for Acorn DOS Plus

end.
