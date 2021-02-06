unit MainUnit;

//This project is now covered by the GNU GPL v3 licence

{$MODE objFPC}

interface

uses
  SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,DiscImage,Global,
  DiscImageUtils,ExtCtrls,Buttons,ComCtrls,Menus,DateUtils,ImgList,StrUtils;

type
 //We need a custom TTreeNode, as we want to tag on some extra information
 TMyTreeNode = class(TTreeNode)
  private
   FDir     : Integer;
   FIsDir   : Boolean;
  public
   property Dir     : Integer read FDir write FDir;     //Directory reference
   property IsDir   : Boolean read FIsDir write FIsDir; //Is it a directory
 end;
 //Form definition

  { TMainForm }

  TMainForm = class(TForm)
   cb_private: TCheckBox;
   cb_ownerwrite: TCheckBox;
   cb_ownerread: TCheckBox;
   cb_ownerlocked: TCheckBox;
   cb_ownerexecute: TCheckBox;
   cb_publicread: TCheckBox;
   cb_publicwrite: TCheckBox;
   cb_publicexecute: TCheckBox;
   ed_title: TEdit;
   ed_filenamesearch: TEdit;
   ed_filetypesearch: TEdit;
   ed_lengthsearch: TEdit;
   icons: TImageList;
   FullSizeTypes: TImageList;
   FileImages: TImageList;
   imgCopy: TImage;
   Label15: TLabel;
   Label16: TLabel;
   Label7: TLabel;
   lb_CRC32: TLabel;
   Main_Menu: TMainMenu;
   FileMenu: TMenuItem;
   MenuItem1: TMenuItem;
   menuCloseImage: TMenuItem;
   menuRenameFile: TMenuItem;
   menuNewDir: TMenuItem;
   menuDeleteFile: TMenuItem;
   menuAbout: TMenuItem;
   ImageMenu: TMenuItem;
   HelpMenu: TMenuItem;
   menuNewImage: TMenuItem;
   menuOpenImage: TMenuItem;
   menuSaveImage: TMenuItem;
   menuImageDetails: TMenuItem;
   menuExtractFile: TMenuItem;
   menuAddFile: TMenuItem;
   ToolBarImages: TImageList;
   Label10: TLabel;
   Label14: TLabel;
   Label8: TLabel;
   Label9: TLabel;
   AddNewFile: TOpenDialog;
   Panel1: TPanel;
   SaveImage: TSaveDialog;
   sb_search: TSpeedButton;
   searchresultscount: TLabel;
   ToolBar1: TToolBar;
   btn_OpenImage: TToolButton;
   btn_SaveImage: TToolButton;
   btn_Delete: TToolButton;
   btn_Rename: TToolButton;
   btn_AddFiles: TToolButton;
   btn_NewImage: TToolButton;
   btn_ImageDetails: TToolButton;
   btn_NewDirectory: TToolButton;
   btn_CloseImage: TToolButton;
   ToolButton3: TToolButton;
   btn_download: TToolButton;
   ToolButton5: TToolButton;
   btn_About: TToolButton;
   ToolPanel: TPanel;
   OpenImageFile: TOpenDialog;
   ExtractDialogue: TSaveDialog;
   DirList: TTreeView;
   FileInfoPanel: TPanel;
   img_FileType: TImage;
   lb_FileName: TLabel;
   Label1: TLabel;
   lb_FileType: TLabel;
   Label3: TLabel;
   Label2: TLabel;
   lb_execaddr: TLabel;
   lb_loadaddr: TLabel;
   Label6: TLabel;
   lb_timestamp: TLabel;
   Label5: TLabel;
   Label11: TLabel;
   lb_length: TLabel;
   lb_Parent: TLabel;
   Label12: TLabel;
   lb_title: TLabel;
   Label13: TLabel;
   Label4: TLabel;
   lb_location: TLabel;
   Label21: TLabel;
   ImageContentsPanel: TPanel;
   lb_contents: TLabel;
   SearchPanel: TPanel;
   lb_searchresults: TListBox;
   FIle_Menu: TPopupMenu;
   ExtractFile1: TMenuItem;
   RenameFile1: TMenuItem;
   DeleteFile1: TMenuItem;
   ImageDetails: TStatusBar;
   AddFile1: TMenuItem;
   NewDirectory1: TMenuItem;
   procedure btn_CloseImageClick(Sender: TObject);
   procedure btn_ImageDetailsClick(Sender: TObject);
   procedure btn_NewDirectoryClick(Sender: TObject);
   function CreateDirectory(dirname,attr: AnsiString): TTreeNode;
   procedure DirListMouseDown(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
   procedure DraggedItemMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
   procedure DraggedItemMouseUp(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
   procedure DirListMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
   function GetCopyMode(Shift: TShiftState): Boolean;
   procedure DirListMouseUp(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
   procedure ed_titleEditingDone(Sender: TObject);
   procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
   procedure FormDropFiles(Sender: TObject; const FileNames: array of AnsiString);
   procedure lb_titleClick(Sender: TObject);
   function QueryUnsaved: Boolean;
   procedure btn_NewImageClick(Sender: TObject);
   procedure btn_SaveImageClick(Sender: TObject);
   procedure AttributeChangeClick(Sender: TObject);
   function GetFilePath(Node: TTreeNode): AnsiString;
   procedure DeleteFile1Click(Sender: TObject);
   procedure DeleteFile(confirm: Boolean);
   procedure DirListCreateNodeClass(Sender: TCustomTreeView; var NodeClass: TTreeNodeClass);
   procedure DirListEditingEnd(Sender: TObject; Node: TTreeNode;
    Cancel: Boolean);
   procedure DirListGetImageIndex(Sender: TObject; Node: TTreeNode);
   procedure FormResize(Sender: TObject);
   procedure FormShow(Sender: TObject);
   procedure DisableControls;
   procedure ParseCommandLine(cmd: AnsiString);
   procedure RenameFile1Click(Sender: TObject);
   procedure ResetFileFields;
   procedure ResetSearchFields;
   procedure btn_downloadClick(Sender: TObject);
   function GetImageFilename(dir,entry: Integer): AnsiString;
   function GetWindowsFilename(dir,entry: Integer): AnsiString;
   procedure DownLoadFile(dir,entry: Integer; path: AnsiString);
   procedure CreateINFFile(dir,entry: Integer; path: AnsiString);
   procedure DownLoadDirectory(dir,entry: Integer; path: AnsiString);
   procedure btn_OpenImageClick(Sender: TObject);
   procedure OpenImage(filename: AnsiString);
   procedure ShowNewImage(title: AnsiString);
   function ConvertToKMG(size: Int64): AnsiString;
   function IntToStrComma(size: Int64): AnsiString;
   procedure DirListChange(Sender: TObject; Node: TTreeNode);
   procedure btn_AboutClick(Sender: TObject);
   procedure FormCreate(Sender: TObject);
   procedure ImageDetailsDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
    const Rect: TRect);
   procedure ValidateFilename(var f: AnsiString);
   procedure sb_searchClick(Sender: TObject);
   procedure lb_searchresultsClick(Sender: TObject);
   procedure SelectNode(filename: AnsiString);
   procedure DirListEditing(Sender: TObject; Node: TTreeNode;
     var AllowEdit: Boolean);
   procedure DirListDblClick(Sender: TObject);
   procedure AddFile1Click(Sender: TObject);
   function AddFileToTree(ParentNode: TTreeNode;importfilename: AnsiString;
                                  index: Integer;dir: Boolean): TTreeNode;
   procedure AddDirectoryToImage(dirname: AnsiString);
   procedure AddFileToImage(filename: AnsiString);
   procedure UpdateImageInfo;
   procedure ReportError(error: AnsiString);
  private
   var
    //To keep track of renames
    PathBeforeEdit,
    NameBeforeEdit:AnsiString;
    //Stop the checkbox OnClick from firing when just changing the values
    DoNotUpdate   :Boolean;
    //Has the image changed since last saved?
    HasChanged    :Boolean;
    //Item being dragged on Directory List
    DraggedItem   :TTreeNode;
    //To keep track of if we are dragging and if the mouse button is down
    IsDragging,
    MouseIsDown   :Boolean;
    //To remember where we started with the drag operation
    CursorPos     :TPoint;
    //The mouse 'cursor' while we are dragging
    ObjectDrag    :TImage;
   const
    //RISC OS Filetypes - used to locate the appropriate icon in the ImageList
    FileTypes: array[3..139] of AnsiString =
                              ('1AD','3FB','6A2','18A','68E','69C','69D','69E',
                               '102','108','132','690','695','697','698','699',
                               'AAD','ABA','ABF','ACA','AD0','ADF','AE4','AE6',
                               'AE7','AE9','AF1','AFF','B2F','B9F','B24','B25',
                               'B26','B27','B28','B60','B61','BA6','BBC','BD6',
                               'BD9','BDA','BDF','BE8','BF8','C1D','C1E','C7D',
                               'C27','C32','C46','C85','CAE','CE5','D00','D01',
                               'D3C','D94','DB0','DDC','DEA','DFE','F7A','F7B',
                               'F7E','F7F','F9D','F9E','F9F','F80','F89','F91',
                               'FAE','FAF','FB1','FB2','FB4','FC2','FC3','FC6',
                               'FC8','FCA','FCC','FD3','FD4','FD6','FD7','FDC',
                               'FE1','FE4','FE5','FE6','FEA','FEB','FEC','FED',
                               'FF0','FF1','FF2','FF4','FF5','FF6','FF7','FF8',
                               'FF9','FFA','FFB','FFC','FFD','FFE','FFF','0E1',
                               '1A6','004','11D','19B','69A','69B','190','191',
                               '194','195','196','691','692','693','694','696',
                               'A91','B22','B62','F78','F79','F83','FB0','FCD',
                               'FCE');
    //Windows extension - used to translate from RISC OS to Windows
    Extensions: array[1..42] of AnsiString =
                         ('004aim','132ico' ,'190dsk' ,'198z80'   ,'1A6CPM',
                          '692img','693iff' ,'695gif' ,'697pcx'   ,'698qrt',
                          '699mtv','69Cbmp' ,'69Dtga' ,'69Epbm'   ,'A91zip',
                          'AADsvg','ABFcab' ,'ADFpdf' ,'B60png'   ,'BBCrom',
                          'C46tar','C85jpg' ,'C85jpeg','DDCarc'   ,'DDCarchive',
                          'DEAdxf','F76edid','F78jng' ,'F79css'   ,'F81js',
                          'F83mng','F91uri' ,'FAFhtm' ,'FAFhtml'  ,'FE4dos',
                          'FF0tif','FF0tiff','FF6ttf' ,'FF9sprite','FFBbas',
                          'FFDdat','FFFtxt');
    //These point to certain icons used when no filetype is found, or non-ADFS
    appicon =   0;
    directory   =   1;
    directory_o =   2;
    loadexec    = 140; //(+1)RISC OS file with Load/Exec specified
    unknown     = 142; //(+3)RISC OS unknown filetype
    nonadfs     = 144; //(+5)All other filing systems, except for D64/D71/D81
    prgfile     = 143; //(+4)D64/D71/D81 file types
    seqfile     = 144; //(+5)
    usrfile     = 145; //(+6)
    delfile     = 146; //(+7)
    relfile     = 144; //(+5)
    cbmfile     = 144; //(+5)
    //Icons for status bar
    changedicon   = 0;
    acornlogo     = 1;
    amigalogo     = 2;
    bbclogo       = 3;
    commodorelogo = 4;
    riscoslogo    = 5;
    sinclairlogo  = 6;
    //Application Title
    ApplicationTitle   = 'Disc Image Manager';
    ApplicationVersion = '1.05.12';
  public
   //The image - this doesn't need to be public...we are the main form in this
   Image: TDiscImage;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

uses AboutUnit, NewImageUnit, ImageDetailUnit, ProgressUnit;

{------------------------------------------------------------------------------}
//Add a new file to the disc image
{------------------------------------------------------------------------------}
procedure TMainForm.AddFile1Click(Sender: TObject);
var
  i: Integer;
begin
 //Open the dialogue box
 if AddNewFile.Execute then
  if AddNewFile.Files.Count>0 then
   //If more than one file selected, iterate through them
   for i:=0 to AddNewFile.Files.Count-1 do
    if not DirectoryExists(AddNewFile.Files[i]) then
     AddFileToImage(AddNewFile.Files[i]) //Add a single file
    else
     AddDirectoryToImage(AddNewFile.Files[i]); //Add a directory and the contents
end;

{------------------------------------------------------------------------------}
//Add a directory to an image
{------------------------------------------------------------------------------}
procedure TMainForm.AddDirectoryToImage(dirname: AnsiString);
var
 OriginalNode,
 NewNode      : TTreeNode;
 inffile,
 attr,
 importname   : AnsiString;
 F            : TFileStream;
 chr          : Char;
 fields       : array of AnsiString;
 Dir          : TSearchRec;
begin
 //First, if there is no selection, make one, or if multiple, select the root
 if (DirList.SelectionCount=0) OR (DirList.SelectionCount>1) then
 begin
  DirList.ClearSelection;
  DirList.Items[0].Selected:=True;
 end;
 OriginalNode:=DirList.Selected;
 //If ADFS, create the directory, then select it
 if Image.FormatNumber shr 4=1 then
 begin
  importname:=ExtractFilename(dirname);
  attr      :='DLR';
  //Is there an inf file?
  if FileExists(dirname+'.inf') then
  begin
   inffile:='';
   //Read in the first line
   try
    F:=TFileStream.Create(dirname+'.inf',fmOpenRead OR fmShareDenyNone);
    F.Position:=0;
    while (F.Read(chr,1)=1) and (Ord(chr)>31) and (Ord(chr)<127) do
     inffile:=inffile+chr;
    F.Free;
    fields:=BreakDownInf(inffile);
    //Then extract the fields
    if Length(fields)>0 then importname:=fields[0];
    if Length(fields)>4 then attr      :=fields[4];
   except
    //Could not load
   end;
  end;
  //Convert a Windows filename to a BBC filename
  WinToBBC(importname);
  //Remove spaces for non-big directories, and ensure is 10 chars or less
  if Image.DirectoryType<>2 then
  begin
   importname:=ReplaceStr(importname,' ','_');
   importname:=LeftStr(importname,10);
  end;
  //Create the directory
  NewNode:=CreateDirectory(importname,attr);
  if NewNode<>nil then //Success
  begin
   //And select it
   DirList.ClearSelection;
   NewNode.Selected:=True;
   //Now we import everything inside this
   FindFirst(dirname+pathdelim+'*',faDirectory,Dir);
   repeat
    if (Dir.Name<>'.') and (Dir.Name<>'..') then
    begin
     if (Dir.Attr AND faDirectory)=faDirectory then
      AddDirectoryToImage(dirname+pathdelim+Dir.Name)
     else
      AddFileToImage(dirname+pathdelim+Dir.Name);
    end;
   until FindNext(Dir)<>0;
   FindClose(Dir);
  end;
 end;
 //Revert to the original selection
 DirList.ClearSelection;
 OriginalNode.Selected:=True;
end;

{------------------------------------------------------------------------------}
//Add a file to an image
{------------------------------------------------------------------------------}
procedure TMainForm.AddFileToImage(filename: AnsiString);
var
  NewFile        : TDirEntry;
  buffer         : TDIByteArray;
  index          : Integer;
  side           : Cardinal;
  attr2,i        : Byte;
  importfilename,
  inffile,
  execaddr,
  loadaddr,
  filelen,
  attr1,
  attributes,
  filetype       : AnsiString;
  fields         : array of AnsiString;
  chr            : Char;
  F              : TFileStream;
begin
 //First, if there is no selection, make one, or if multiple, select the root
 if (DirList.SelectionCount=0) OR (DirList.SelectionCount>1) then
 begin
  DirList.ClearSelection;
  DirList.Items[0].Selected:=True;
 end;
 //Make sure that there is a destination selected - should be after last command
 if DirList.SelectionCount=1 then
  //And it is a directory
  if TMyTreeNode(DirList.Selected).IsDir then
  begin
   //Find out which side of a DFS disc it is
   if  (Image.FormatNumber mod 2=1)
   and (Image.FormatNumber shr 4=0) then //Only for DFS double sided
   //As with DFS we can only Add with the root selected, the index will be the side
    side:=DirList.Selected.Index
   else
   //Not double sided or DFS, so assume side 0
    side:=0;
   //Extract the filename
   importfilename:=ExtractFileName(filename);
   //Reject any *.inf files
   if LowerCase(RightStr(importfilename,4))<>'.inf' then
   begin
    //Initialise the strings
    execaddr:='00000000';
    loadaddr:='00000000';
    filelen :='00000000';
    attr1   :='00';
    attr2   :=$00;
    filetype:='';
    //Does the filename contain the filetype?
    if ((Pos(',',importfilename)>0)
    or  (Pos('.',importfilename)>0))
    and((Image.FormatNumber shr 4=1)      //ADFS
    or  (Image.FormatNumber shr 4=2))then //Commodore
    begin
     i:=Length(importfilename);
     while (importfilename[i]<>'.')and(importfilename[i]<>',')do dec(i);
     //Get the filetype
     filetype:=LowerCase(Copy(importfilename,i+1));
     //And remove it from the filename
     importfilename:=LeftStr(importfilename,i-1);//Length(importfilename)-4);
     //Decode the filetype - convert it to hex
     for index:=1 to Length(Extensions) do
      if Copy(Extensions[index],4)=LowerCase(filetype) then
       filetype:=LeftStr(Extensions[index],3);
     //ADFS
     if Image.FormatNumber shr 4=1 then
     begin
      filetype:=IntToHex(StrToIntDef('$'+filetype,0),3);
      if filetype='000' then filetype:='';//None, so reset
     end;
    end;
    if Image.FormatNumber<$20 then //ADFS and DFS only stuff
    begin
     //Is there an inf file?
     if FileExists(filename+'.inf') then
     begin
      inffile:='';
      //Read in the first line
      try
       F:=TFileStream.Create(filename+'.inf',fmOpenRead OR fmShareDenyNone);
       F.Position:=0;
       while (F.Read(chr,1)=1) and (Ord(chr)>31) and (Ord(chr)<127) do
        inffile:=inffile+chr;
       F.Free;
       fields:=BreakDownInf(inffile);
       //Then extract the fields
       if Length(fields)>0 then importfilename:=fields[0];
       if Length(fields)>1 then loadaddr      :=fields[1];
       if length(fields)>2 then execaddr      :=fields[2];
       if Length(fields)>3 then filelen       :=fields[3];
       if Length(fields)>4 then attr1         :=fields[4];
      except
       //Could not load
      end;
     end;
     //Remove any extraenous specifiers
     while (importfilename[4]=Image.DirSep) do
      importfilename:=RightStr(importfilename,Length(importfilename)-2);
     //If root, remove the directory specifier
     if (importfilename[2]=Image.DirSep) and (importfilename[1]='$') then
      importfilename:=RightStr(importfilename,Length(importfilename)-2);
     //Convert a Windows filename to a BBC filename
     WinToBBC(importfilename);
     //Check to make sure that a DFS directory hasn't been changed
     if (Image.FormatNumber<$20) and (importfilename[2]='/') then
      importfilename[2]:=Image.DirSep;
     //Remove any spaces, unless it is a big directory
     if Image.DirectoryType<>2 then
      importfilename:=ReplaceStr(importfilename,' ','_');
    end;
    //Initialise the TDirArray
    ResetDirEntry(NewFile);
    //Initialise the buffer
    SetLength(buffer,0);
    //Decode the attributes
    attributes        :=''; //Default
    if Image.FormatNumber shr 4=$1 then attributes:='WR';//Default for ADFS
    if Image.FormatNumber shr 4=$3 then attributes:='C' ;//Default for Commodore
    //Is it a hex number?
    if IntToHex(StrtoIntDef('$'+attr1,0),2)=UpperCase(attr1) then
    begin //Yes
     attr2:=StrToInt('$'+attr1);
     attr1:='';
    end;
    //Read each attribute and build the string
    if Image.FormatNumber shr 4<$3 then //ADFS and DFS
     if (Pos('L',attr1)>0)OR(attr2 AND$08=$08) then attributes:=attributes+'L';
    if Image.FormatNumber shr 4=$2 then //ADFS only
    begin
     if (Pos('R',attr1)>0)OR(attr2 AND$01=$01) then attributes:=attributes+'R';
     if (Pos('W',attr1)>0)OR(attr2 AND$02=$02) then attributes:=attributes+'W';
     if (Pos('E',attr1)>0)OR(attr2 AND$04=$04) then attributes:=attributes+'E';
     if (Pos('r',attr1)>0)OR(attr2 AND$10=$10) then attributes:=attributes+'r';
     if (Pos('w',attr1)>0)OR(attr2 AND$20=$20) then attributes:=attributes+'w';
     if (Pos('e',attr1)>0)OR(attr2 AND$40=$40) then attributes:=attributes+'e';
     if (Pos('l',attr1)>0)OR(attr2 AND$80=$80) then attributes:=attributes+'l';
    end;
    //Setup the record
    NewFile.Filename     :=importfilename;
    NewFile.ExecAddr     :=StrToInt('$'+execaddr);
    NewFile.LoadAddr     :=StrToInt('$'+loadaddr);
    NewFile.Side         :=side;
    NewFile.Attributes   :=attributes;
    NewFile.DirRef       :=-1; //Not a directory
    NewFile.ShortFileType:=filetype;
    if Image.FormatNumber shr 4=1 then //Need the selected directory for ADFS
     if DirList.Selected.Text='$' then NewFile.Parent:='$'
     else
      NewFile.Parent    :=GetImageFilename(TMyTreeNode(DirList.Selected).Dir,
                                           DirList.Selected.Index);
    //Load the file from the host
    try
     F:=TFileStream.Create(filename,fmOpenRead OR fmShareDenyNone);
     F.Position:=0;
     //If the supplied file length is zero, use the system size
     if StrToIntDef('$'+filelen,F.Size)=0 then filelen:=IntToHex(F.Size,8);
     //Set the buffer length to either the length supplied, or what the host returns
     SetLength(buffer,StrToIntDef('$'+filelen,F.Size));
     //Set the length to the actual number of bytes read in
     NewFile.Length    :=F.Read(buffer[0],StrToIntDef('$'+filelen,F.Size));
     F.Free;
     //Write the File
     index:=Image.WriteFile(NewFile,buffer);
    except
     index:=-1;//Could not load
    end;
    //Function returns pointer to next item (or parent if no children)
    if index>-1 then //File added OK
     AddFileToTree(DirList.Selected,NewFile.Filename,index,False)
    else
    begin
     //For some reason the operation failed to write the data
     if index=-1 then ReportError('Could not load "'+filename+'"');
     if index=-2 then ReportError('Could not add file - image full');
     if index=-3 then ReportError('File already exists in image');
     if index=-4 then ReportError('Catalogue full');
     if index=-5 then ReportError('Could not write file - error unknown');
     if index=-6 then ReportError('Destination directory does not exist');
     If index=-7 then ReportError('Could not write file - map full');
     if index=-8 then ReportError('Could not write file - nothing to write');
    end;
   end;
  end
  else ReportError('"'+DirList.Selected.Text+'" is not a directory')
 else
  if DirList.SelectionCount=0 then
   ReportError('No destination directory selected')
  else
   ReportError('Cannot add to multiple selection');
end;

{------------------------------------------------------------------------------}
//Add a file or directory to the TTreeView, under ParentNode
{------------------------------------------------------------------------------}
function TMainForm.AddFileToTree(ParentNode: TTreeNode;importfilename: AnsiString;
                                  index: Integer;dir: Boolean): TTreeNode;
begin
 Result:=nil;
 HasChanged:=True;
 //Now add the entry to the Directory List
 if ParentNode.HasChildren then
  //Insert it before the one specified
  if index<ParentNode.Count then
   Result:=DirList.Items.Insert(ParentNode.Items[index],importfilename)
  else //Unless this is the last one
   Result:=DirList.Items.AddChild(ParentNode,importfilename)
 else
  //Is the first child, so just add it
  Result:=DirList.Items.AddChildFirst(ParentNode,importfilename);
 if ParentNode.Parent<>nil then //No parent, so will be the root
  TMyTreeNode(Result).Dir:=Image.Disc[TMyTreeNode(ParentNode).Dir].
                                     Entries[ParentNode.Index].DirRef
 else
  TMyTreeNode(Result).Dir:=ParentNode.Index; //But may not be the only root
 TMyTreeNode(Result).IsDir:=dir;
 //And update the free space display
 UpdateImageInfo;
end;

{------------------------------------------------------------------------------}
//About box
{------------------------------------------------------------------------------}
procedure TMainForm.btn_AboutClick(Sender: TObject);
var
 platform: AnsiString;
begin
 //Update the Application Title
 AboutForm.lb_Title.Caption:=ApplicationTitle;
 //Determine the current platform (compile time directive)
 platform:='';
 {$IFDEF Darwin}
 platform:=' macOS';            //Apple Mac OS X
 {$ENDIF}
 {$IFDEF Windows}
 platform:=' Windows';          //Microsoft Windows
 {$ENDIF}
 {$IFDEF Linux}
 platform:=' Linux';            //Linux
 {$ENDIF}
 {$IFDEF CPU32}
 platform:=platform+' 32 bit';  //32 bit CPU
 {$ENDIF}
 {$IFDEF CPU64}
 platform:=platform+' 64 bit';  //64 bit CPU
 {$ENDIF}
 {$IFDEF CPUARM}
 platform:=platform+' ARM';     //ARM CPU
 {$ENDIF}
 //Update the Application Version
 AboutForm.lb_Version.Caption:='Version '+ApplicationVersion+platform;
 //Show the Form, as a modal
 AboutForm.ShowModal;
end;

{------------------------------------------------------------------------------}
//User has clicked download file button
{------------------------------------------------------------------------------}
procedure TMainForm.btn_downloadClick(Sender: TObject);
var
 Node       : TTreeNode;
 entry,
 dir,s      : Integer;
 saver,
 showsave,
 selectroot : Boolean;
begin
 selectroot:=False;
 showsave:=False;
 //if the root is selected, then select everything else
 if DirList.Items[0].Selected then
 begin
  selectroot:=True;
  //Deselect the root
  DirList.ClearSelection;
  //Does it have children?
  if DirList.Items.Item[0].HasChildren then
  begin
   //Go through them, starting at the first child
   Node:=DirList.Items.Item[0].GetFirstChild;
   //Continue until we run out of children
   while Node<>nil do
   begin
    //Select it
    Node.Selected:=True;
    //And get the next one, if there is one
    Node:=Node.GetNextSibling;
   end;
  end;
 end;
 //Only continue if something is selected
 if DirList.SelectionCount>0 then
  for s:=0 to DirList.SelectionCount-1 do
   begin
    //Get one of the selected Nodes
    Node:=DirList.Selections[s];
    //Only act on it if there is one selected
    if Node<>nil then
     begin
      //Get the entry and directory references into 'Image'
      entry:=Node.Index;
      dir:=-1;//This will remain as -1 with the root
      if Node.Parent<>nil then
       dir  :=TMyTreeNode(Node).Dir;
      if dir>=0 then //dir = -1 would be the root
      begin
       //Open the Save As dialogue box, but only if the first in the list
       saver:=False;
       if not showsave then
       begin
        //Indicate that we have shown the dialogue
        showsave:=True;
        //Set the default filename
        if selectroot then //Root was selected
        begin
         //Set the default filename as either the disc title or '$'
         if Image.Title='' then
          ExtractDialogue.FileName:=DirList.Items[0].Text
         else
          ExtractDialogue.FileName:=Image.Title;
        end
        else
         ExtractDialogue.FileName:=GetWindowsFilename(dir,entry);
        //Get the result
        saver:=ExtractDialogue.Execute;
        //User clicked on Cancel, so exit
        if not saver then exit;
        if (saver) and (selectroot) then //Root was selected, so create the directory
        begin
         CreateDir(ExtractDialogue.FileName);
         ExtractDialogue.Filename:=ExtractDialogue.Filename+PathDelim+'root';
        end;
       end;
       if s>0 then saver:=True;
       //Download a single file
       if saver then
        //Do not download if the parent is selected, as this will get downloaded anyway
        if not DirList.Selections[s].Parent.Selected then
         DownLoadFile(dir,entry,ExtractFilePath(ExtractDialogue.FileName));
      end;
     end;
   end;
end;

{------------------------------------------------------------------------------}
//Create an Image filename
{------------------------------------------------------------------------------}
function TMainForm.GetImageFilename(dir,entry: Integer): AnsiString;
begin
 if Length(Image.Disc[dir].Entries)=0 then
  Result:=Image.Disc[dir].Directory
 else
  Result:=Image.Disc[dir].Entries[entry].Parent+Image.DirSep
         +Image.Disc[dir].Entries[entry].Filename;
end;

{------------------------------------------------------------------------------}
//Create a Windows filename
{------------------------------------------------------------------------------}
function TMainForm.GetWindowsFilename(dir,entry: Integer): AnsiString;
var
 extsep: Char;
begin
 //Get the filename
 Result:=Image.Disc[dir].Entries[entry].Filename;
 //Convert BBC chars to PC
 BBCtoWin(Result);
 //Replace any non-valid characters
 ValidateFilename(Result);
 //Add the filetype to the end, if any (but not directories)
 if (Image.Disc[dir].Entries[entry].ShortFileType<>'')
 and(Image.Disc[dir].Entries[entry].DirRef=-1) then
 begin
  if Image.FormatNumber shr 4<2 then extsep:=','; //DFS and ADFS
  if(Image.FormatNumber shr 4=2)                  //Commodore
  or(Image.FormatNumber shr 4=4)then extsep:='.'; //Amiga
  Result:=Result+extsep+Image.Disc[dir].Entries[entry].ShortFileType;
 end;
end;

{------------------------------------------------------------------------------}
//Download a file
{------------------------------------------------------------------------------}
procedure TMainForm.DownLoadFile(dir,entry: Integer;path: AnsiString);
var
 F              : TFileStream;
 buffer         : TDIByteArray;
 imagefilename,
 windowsfilename: AnsiString;
begin
 // Ensure path ends in a directory separator
 if path[Length(path)]<>PathDelim then path:=path+PathDelim;
 //Object is a file, so download it
 if Image.Disc[dir].Entries[entry].DirRef=-1 then
 begin
  //Get the full path and filename
  imagefilename  :=GetImageFilename(dir,entry);
  windowsfilename:=GetWindowsFilename(dir,entry);
  if Image.ExtractFile(imagefilename,buffer) then
  begin
   //Save the buffer to the file
   try
    F:=TFileStream.Create(path+windowsfilename,fmCreate OR fmShareDenyNone);
    F.Position:=0;
    F.Write(buffer[0],Length(buffer));
    F.Free;
    CreateINFFile(dir,entry,path);
   except
    //Could not create file
   end;
  end
  //Happens if the file could not be located
  else ReportError('Could not locate file "'+imagefilename+'"');
 end
 else DownLoadDirectory(dir,entry,path+windowsfilename);
end;

{------------------------------------------------------------------------------}
//Create an inf file - MOVE INTO THE UTILS MODULE
{------------------------------------------------------------------------------}
procedure TMainForm.CreateINFFile(dir,entry: Integer; path: AnsiString);
var
 F              : TFileStream;
 inffile,
 imagefilename,
 windowsfilename: AnsiString;
 attributes     : Byte;
 t              : Integer;
const
 adfsattr = 'RWELrwel';
begin
 //DFS and ADFS only
 if Image.FormatNumber shr 4<2 then
 begin
  imagefilename:=Image.Disc[dir].Entries[entry].Filename;
  windowsfilename:=GetWindowsFilename(dir,entry);
  //Put quotes round the filename if it contains a space
  if Pos(' ',imagefilename)>0 then imagefilename:='"'+imagefilename+'"';
  //Create the string
  inffile:=PadRight(LeftStr(imagefilename,12),12)+' '
          +IntToHex(Image.Disc[dir].Entries[entry].LoadAddr,8)+' '
          +IntToHex(Image.Disc[dir].Entries[entry].ExecAddr,8)+' '
          +IntToHex(Image.Disc[dir].Entries[entry].Length,8);
  //Create the attributes
  attributes:=$00;
  if Image.FormatNumber shr 4=0 then //DFS
   if Image.Disc[dir].Entries[entry].Attributes='L' then attributes:=$08;
  if Image.FormatNumber shr 4=1 then //ADFS
   for t:=0 to 7 do
    if Pos(adfsattr[t+1],Image.Disc[dir].Entries[entry].Attributes)>0 then
     inc(attributes,1 shl t);
  inffile:=inffile+' '+IntToHex(attributes,2)
          +' CRC32:'+Image.GetFileCRC(Image.Disc[dir].Entries[entry].Parent+
                                      Image.DirSep+
                                      Image.Disc[dir].Entries[entry].Filename);
  //Create the inf file
  try
   F:=TFileStream.Create(path+windowsfilename+'.inf',fmCreate OR fmShareDenyNone);
   F.Position:=0;
   F.Write(inffile[1],Length(inffile));
   F.Free;
  except
   //Could not create
  end;
 end;
end;

{------------------------------------------------------------------------------}
//Download an entire directory
{------------------------------------------------------------------------------}
procedure TMainForm.DownLoadDirectory(dir,entry: Integer;path: AnsiString);
var
 imagefilename,
 windowsfilename: AnsiString;
 ref            : Cardinal;
 c,s            : Integer;
begin
 ref:=0;
 // Ensure path ends in a directory separator
 if path[Length(path)]<>PathDelim then path:=path+PathDelim;
 //Get the full path and filename
 imagefilename:=GetImageFilename(dir,entry);
 //Convert to Windows filename
 windowsfilename:=GetWindowsFilename(dir,entry);
 if Image.FileExists(imagefilename,ref) then
 begin
  //Create the directory
  if not DirectoryExists(path+windowsfilename) then
  begin
   CreateDir(path+windowsfilename);
   CreateINFFile(dir,entry,path);
  end;
  //Navigate into the directory
  s:=Image.Disc[dir].Entries[entry].DirRef;
  //Iterate through the entries
  for c:=0 to Length(Image.Disc[s].Entries)-1 do
   DownLoadFile(s,c,path+windowsfilename);
 end
 //Happens if the file could not be located
 else ReportError('Could not locate directory "'+imagefilename+'"');
end;

{------------------------------------------------------------------------------}
//User has clicked on the button to open a new image
{------------------------------------------------------------------------------}
procedure TMainForm.btn_OpenImageClick(Sender: TObject);
begin
 if QueryUnsaved then
  //Show the open file dialogue box
  if OpenImageFile.Execute then
  begin
   //Show a progress message
   ProgressForm.Show;
   //Process the messages to close the file dialogue box
   Application.ProcessMessages;
   //And then open the image
   OpenImage(OpenImageFile.FileName);
   //Close the progress message
   ProgressForm.Hide;
  end;
end;

{------------------------------------------------------------------------------}
//Open a disc image from file
{------------------------------------------------------------------------------}
procedure TMainForm.OpenImage(filename: AnsiString);
begin
 //Load the image and create the catalogue
 if Image.LoadFromFile(filename) then
 begin
  HasChanged:=False;
  //Update the display
  ShowNewImage(Image.Filename);
 end
 else
  ReportError('"'+filename
                        +'" has not been recognised as a valid disc image that '
                        +ApplicationTitle+' can open.');
end;

{------------------------------------------------------------------------------}
//Reset the display for a new/loaded image
{------------------------------------------------------------------------------}
procedure TMainForm.ShowNewImage(title: AnsiString);
var
 //Used as a marker to make sure all directories are displayed.
 //Some double sided discs have each side as separate discs
 highdir    : Integer;
 //Adds a directory to the TreeView - is called recursively to drill down the tree
 procedure AddDirectory(CurrDir: TTreeNode; dir: Integer);
 var
  entry: Integer;
  Node: TTreeNode;
 begin
  //Make a note of the dir ref, it is the highest
  if dir>highdir then highdir:=dir;
  //Set the 'IsDir' flag to true, as this is a directory
  TMyTreeNode(CurrDir).IsDir:=True;
  //Iterate though all the entries
  for entry:=0 to Length(Image.Disc[dir].Entries)-1 do
  begin
   //Adding new nodes for each one
   Node:=DirList.Items.AddChild(CurrDir,Image.Disc[dir].Entries[entry].Filename);
   //Making a note of the dir ref
   TMyTreeNode(Node).Dir:=dir;
   //And setting the IsDir flag to false - this will be set to True if it is a dir
   TMyTreeNode(Node).IsDir:=False;
   //If it is, indeed, a direcotry, the dir ref will point to the sub-dir
   if Image.Disc[dir].Entries[entry].DirRef>=0 then
   //and we'll recursively call ourself to add these entries
    AddDirectory(Node,Image.Disc[dir].Entries[entry].DirRef);
  end;
 end;
begin
  //Clear all the labels, and enable/disable the buttons
  ResetFileFields;
  //Clear the search fields
  ResetSearchFields;
  //Change the application title (what appears on SHIFT+TAB, etc.)
  Caption:=ApplicationTitle;
  if title<>'' then Caption:=Caption+' - '+ExtractFileName(title);
  //If the format is a recognised one
  if Image.FormatString<>'' then
  begin
   //Populate the tree view
   DirList.Items.Clear;
   //Set the highdir to zero - which will be root to start with
   highdir:=0;
   //Then add the directories, if there is at least one
   if Length(Image.Disc)>0 then
   begin
    //Start by adding the root (could be more than one root, particularly on
    //double sided discs)
    repeat
     //This will initiate the recursion through the directory structure, per side
     AddDirectory(DirList.Items.Add(nil,Image.Disc[highdir].Directory),highdir);
     //Finished on this directory structure, so increase the highdir
     inc(highdir);
     //and continue until we have everything on the disc. This will, in effect,
     //add the second root for double sided discs.
    until highdir=Length(Image.Disc);
    //Expand the top level of the tree
    DirList.TopItem.Expand(False);
    //And the root for the other side of the disc
    if Image.DoubleSided then
    begin
     //First, we need to find it
     repeat
      inc(highdir)
      //If there is one, of course - but it must be a directory
     until (highdir>=DirList.Items.Count) or (TMyTreeNode(DirList.Items[highdir-1]).IsDir);
     if highdir>DirList.Items.Count then
      highdir:=DirList.Items.Count;
     //Found? then expand it
     if TMyTreeNode(DirList.Items[highdir-1]).IsDir then
      DirList.Items[highdir-1].Expand(False);
    end;
   end;
   //Populate the info box
   UpdateImageInfo;
   //Enable the controls
   btn_SaveImage.Enabled:=True;
   menuSaveImage.Enabled:=True;
   btn_CloseImage.Enabled:=True;
   menuCloseImage.Enabled:=True;
   if Length(Image.FreeSpaceMap)>0 then
   begin
    btn_ImageDetails.Enabled:=True;
    menuImageDetails.Enabled:=True;
   end;
   //Enable the search area
   ed_filenamesearch.Enabled:=True;
   ed_lengthsearch.Enabled  :=True;
   ed_filetypesearch.Enabled:=True;
   lb_searchresults.Enabled :=True;
   sb_search.Enabled        :=True;
   //Enable the directory view
   DirList.Enabled:=True;
  end;
end;

{------------------------------------------------------------------------------}
//Update the Image information display
{------------------------------------------------------------------------------}
procedure TMainForm.UpdateImageInfo;
var
 i: Integer;
 title: AnsiString;
begin
 //Only if there is a valid image
 if Image.FormatNumber<>$FF then
 begin
  //Image Format
  ImageDetails.Panels[1].Text:=Image.FormatString;
  //Disc name
  title:=Image.Title;
  RemoveTopBit(title);//Ensure top bit not set
  ImageDetails.Panels[2].Text:=title;
  //Disc size
  ImageDetails.Panels[3].Text:=ConvertToKMG(Image.DiscSize)
                           +' ('+IntToStrComma(Image.DiscSize)+' Bytes)';
  //Free space
  ImageDetails.Panels[4].Text:=ConvertToKMG(Image.FreeSpace)
                           +' ('+IntToStrComma(Image.FreeSpace)+' Bytes)';
  //Double sided or not
  if Image.DoubleSided then
   ImageDetails.Panels[5].Text:='Double Sided'
  else
   ImageDetails.Panels[5].Text:='Single Sided';
  //Map type (ADFS/AmigaDOS only)
  ImageDetails.Panels[6].Text:=Image.MapTypeString;
  //Directory type (ADFS/AmigaDOS only)
  ImageDetails.Panels[7].Text:=Image.DirectoryTypeString;
 end
 else //Reset all to blank
  for i:=1 to 7 do ImageDetails.Panels[i].Text:='';
 //Update the status bar
 ImageDetails.Repaint;
end;

{------------------------------------------------------------------------------}
//This is called when the selection changes on the TreeView
{------------------------------------------------------------------------------}
procedure TMainForm.DirListChange(Sender: TObject; Node: TTreeNode);
var
 entry,
 dir,
 ft       : Integer;
 filename,
 filetype,
 location,
 title    : AnsiString;
 multiple : Char;
begin
 //Reset the fields to blank
 ResetFileFields;
 //More than one?
 multiple:=' ';
 if DirList.SelectionCount>1 then
  multiple:='s';
 //Change the menu names - we'll change these to 'Directory', if needed, later
 ExtractFile1.Caption   :='&Extract File'+multiple;
 menuExtractFile.Caption:='&Extract File'+multiple;
 btn_download.Hint      :='Extract File'+multiple;
 RenameFile1.Caption    :='&Rename File'+multiple;
 menuRenameFile.Caption :='&Rename File'+multiple;
 btn_Rename.Hint        :='Rename File'+multiple;
 DeleteFile1.Caption    :='&Delete File'+multiple;
 menuDeleteFile.Caption :='&Delete File'+multiple;
 btn_Delete.Hint        :='Delete File'+multiple;
 //Enable the buttons, if there is a selection, otherwise disable
 btn_download.Enabled   :=DirList.SelectionCount>0;
 ExtractFile1.Enabled   :=DirList.SelectionCount>0;
 menuExtractFile.Enabled:=DirList.SelectionCount>0;
 DeleteFile1.Enabled    :=DirList.SelectionCount>0;
 btn_Delete.Enabled     :=DirList.SelectionCount>0;
 menuDeleteFile.Enabled :=DirList.SelectionCount>0;
 //Disable the Add Files and Rename menu
 AddFile1.Enabled        :=False;
 btn_AddFiles.Enabled    :=False;
 menuAddFile.Enabled     :=False;
 RenameFile1.Enabled     :=False;
 btn_Rename.Enabled      :=False;
 menuRenameFile.Enabled  :=False;
 NewDirectory1.Enabled   :=False;
 btn_NewDirectory.Enabled:=False;
 menuNewDir.Enabled      :=False;
 //If only a single item selected
 if (Node<>nil) and (DirList.SelectionCount=1) then
 begin
  //Update the image
  DirListGetImageIndex(Sender, Node);
  //Enable the Add Files and Rename menu
  AddFile1.Enabled      :=True;
  btn_AddFiles.Enabled  :=True;
  menuAddFile.Enabled   :=True;
  RenameFile1.Enabled   :=True;
  btn_Rename.Enabled    :=True;
  menuRenameFile.Enabled:=True;
  if(Image.FormatNumber shr 4=1)OR(Image.FormatNumber shr 4=4)then //ADFS and Amiga
  begin
   NewDirectory1.Enabled   :=True;
   btn_NewDirectory.Enabled:=True;
   menuNewDir.Enabled      :=True;
  end;
  //Get the entry and dir references
  entry:=Node.Index;
  dir:=-1;
  //Clear the filename variable
  filename:='';
  //If the node does not have a parent, then the dir ref is the one contained
  //in the extra info. Otherwise is -1
  if Node.Parent<>nil then
   dir  :=TMyTreeNode(Node).Dir;
  //Then, get the filename and filetype of the file...not directory
  if dir>=0 then
  begin
   filename:=Image.Disc[dir].Entries[entry].Filename;
   //Attributes
   DoNotUpdate   :=True; //Make sure the event doesn't fire
   cb_ownerwrite.Checked   :=Pos('W',Image.Disc[dir].Entries[entry].Attributes)>0;
   cb_ownerread.Checked    :=Pos('R',Image.Disc[dir].Entries[entry].Attributes)>0;
   cb_ownerlocked.Checked  :=Pos('L',Image.Disc[dir].Entries[entry].Attributes)>0;
   cb_ownerexecute.Checked :=Pos('E',Image.Disc[dir].Entries[entry].Attributes)>0;
   cb_ownerexecute.Checked :=Pos('C',Image.Disc[dir].Entries[entry].Attributes)>0;
   cb_publicwrite.Checked  :=Pos('w',Image.Disc[dir].Entries[entry].Attributes)>0;
   cb_publicread.Checked   :=Pos('r',Image.Disc[dir].Entries[entry].Attributes)>0;
   cb_publicexecute.Checked:=Pos('e',Image.Disc[dir].Entries[entry].Attributes)>0;
   cb_private.Checked      :=Pos('P',Image.Disc[dir].Entries[entry].Attributes)>0;
   //Enable whichever tickboxes are appropriate to the system
   if (Image.FormatNumber div $10=0)      //DFS
   or (Image.FormatNumber div $10=2) then //Commodore
    cb_ownerlocked.Visible   :=True;
   cb_ownerexecute.Caption   :='Execute';
   if Image.FormatNumber div $10=2 then   //Commodore
   begin
    cb_ownerexecute.Visible  :=True;
    cb_ownerexecute.Caption  :='Closed';
   end;
   if Image.FormatNumber div $10=1 then   //ADFS
   begin
    cb_ownerwrite.Visible    :=True;
    cb_ownerread.Visible     :=True;
    cb_ownerlocked.Visible   :=True;
    cb_publicwrite.Visible   :=True;
    cb_publicread.Visible    :=True;
    if Image.FormatNumber mod $10<3 then //ADFS Old Directory
    begin
     cb_ownerexecute.Visible  :=True;
     cb_publicexecute.Visible :=True;
     cb_private.Visible       :=True;
    end;
   end;
   DoNotUpdate   :=False;  //Re-enable the event firing
   //Filetype
   filetype:=Image.Disc[dir].Entries[entry].Filetype;
  end
  else //Disable buttons as we are on the root
  begin
   btn_download.Enabled   :=True; //Except for download, as we can now do this
   ExtractFile1.Enabled   :=True;
   menuExtractFile.Enabled:=True;
   DeleteFile1.Enabled    :=False;
   btn_Delete.Enabled     :=False;
   menuDeleteFile.Enabled :=False;
   RenameFile1.Enabled    :=False;
   btn_Rename.Enabled     :=False;
   menuRenameFile.Enabled :=False;
  end;
  //If it is a directory, however, we need to get the filename from somewhere else
  //and the filetype will be either Directory or Application (RISC OS only)
  if TMyTreeNode(Node).IsDir then
  begin
   //Determine if it is a Directory or an ADFS Application
   if dir>=0 then
   begin
    if filename='' then
     filename:=Image.Disc[dir].Directory;
    //Pick up from the Node if it is an application or not
    if Node.ImageIndex=appicon then
     filetype:='Application'
    else
     filetype:='Directory';
    //Change the menu text
    ExtractFile1.Caption   :='&Extract '+filetype;
    menuExtractFile.Caption:='&Extract '+filetype;
    btn_download.Hint      :='Extract '+filetype;
    RenameFile1.Caption    :='&Rename '+filetype;
    menuRenameFile.Caption :='&Rename '+filetype;
    btn_Rename.Hint        :='Rename '+filetype;
    DeleteFile1.Caption    :='&Delete '+filetype;
    menuDeleteFile.Caption :='&Delete '+filetype;
    btn_Delete.Hint        :='Delete '+filetype;
    //Report if directory is broken and include the error code
    if (Image.Disc[dir].Entries[entry].DirRef>=0)
    and(Image.Disc[dir].Entries[entry].DirRef<Length(Image.Disc))then
    begin
     if Image.Disc[Image.Disc[dir].Entries[entry].DirRef].Broken then
      filetype:=filetype+' (BROKEN - 0x'
               +IntToHex(
                  Image.Disc[Image.Disc[dir].Entries[entry].DirRef].ErrorCode
                  ,2)+')';
     //Title of the subdirectory
     lb_title.Caption:=Image.Disc[Image.Disc[dir].Entries[entry].DirRef].Title;
     ed_title.Enabled:=True; //Can be edited
    end;
   end
   else
   begin //Root directory
    filename:=Image.Disc[entry].Directory;
    filetype:='Root Directory';
    title:=Image.Disc[entry].Title;
    RemoveTopBit(title);
    lb_title.Caption:=title; //Title
    ed_title.Enabled:=True; //Can be edited
    //Report if directory is broken and include the error code
    if Image.Disc[entry].Broken then
     filetype:=filetype+' (BROKEN - 0x'
                       +IntToHex(Image.Disc[0].ErrorCode,2)+')';
   end;
  end
  else //Can only add files to a directory
  begin
   AddFile1.Enabled        :=False;
   btn_AddFiles.Enabled    :=False;
   menuAddFile.Enabled     :=False;
   NewDirectory1.Enabled   :=False;
   btn_NewDirectory.Enabled:=False;
   menuNewDir.Enabled      :=False;
  end;
  //Filename
  lb_FileName.Caption:=filename;
  //Filetype Image
  ft:=Node.ImageIndex;
  if (ft=directory) or (ft=directory_o) then
  begin
   if Copy(filename,1,1)='!' then //or application
    ft:=appicon
   else
    ft:=directory;
  end;
  //Create a purple background, as a transparent mask
  img_FileType.Transparent:=True;
  img_FileType.Canvas.Pen.Color:=$FF00FF;
  img_FileType.Canvas.Brush.Color:=$FF00FF;
  img_FileType.Canvas.Rectangle(0,0,34,34);
  //Paint the picture onto it
  FullSizeTypes.GetBitmap(ft,img_FileType.Picture.Bitmap);
  //Filetype text
  lb_FileType.Caption:=filetype;
  if dir>=0 then
  begin
   //CRC32
   lb_CRC32.Caption:=Image.GetFileCRC(Image.Disc[dir].Entries[entry].Parent+
                                      Image.DirSep+filename);
   //Parent
   lb_parent.Caption:=Image.Disc[dir].Entries[entry].Parent;
   //Timestamp
   if Image.Disc[dir].Entries[entry].TimeStamp>0 then
    lb_timestamp.Caption:=FormatDateTime('hh:nn:ss dd mmm yyyy',
                                       Image.Disc[dir].Entries[entry].TimeStamp)
   else
    if Image.Disc[dir].Entries[entry].DirRef=-1 then
    begin
     //Load address
     lb_loadaddr.Caption:='0x'+IntToHex(Image.Disc[dir].Entries[entry].LoadAddr,8);
     //Execution address
     lb_execaddr.Caption:='0x'+IntToHex(Image.Disc[dir].Entries[entry].ExecAddr,8);
    end;
   //Length
   lb_length.Caption:=ConvertToKMG(Image.Disc[dir].Entries[entry].Length)+
                   ' (0x'+IntToHex(Image.Disc[dir].Entries[entry].Length,8)+')';
   //Location of object - varies between formats
   location:='';
   //ADFS Old map - Sector is an offset
   if Image.MapType=$00 then
    location:='Offset: 0x'+IntToHex(Image.Disc[dir].Entries[entry].Sector,8)+' ';
   //ADFS New map - Sector is an indirect address (fragment and sector)
   if Image.MapType=$01 then
    location:='Indirect address: 0x'+IntToHex(Image.Disc[dir].Entries[entry].Sector,8)+' ';
   //Commodore formats - Sector and Track
   if ((Image.FormatNumber>=$20) and (Image.FormatNumber<=$2F)) then
    location:='Track ' +IntToStr(Image.Disc[dir].Entries[entry].Track)+' ';
   //All other formats - Sector
   if (Image.FormatNumber<=$0F)
   or ((Image.FormatNumber>=$20) and (Image.FormatNumber<=$2F))
   or ((Image.FormatNumber>=$40) and (Image.FormatNumber<=$4F)) then
    location:=location+'Sector '+IntToStr(Image.Disc[dir].Entries[entry].Sector)+' ';
   //DFS - indicates which side also
   if Image.FormatNumber<=$0F then
    location:=location+'Side '  +IntToStr(Image.Disc[dir].Entries[entry].Side);
   lb_location.Caption:=location;
  end;
  if dir=-1 then
  begin
   //Location of root - varies between formats
   location:='';
   //ADFS Old map - Sector is an offset
   if Image.MapType=$00 then
    location:='Offset: 0x'+IntToHex(Image.RootAddress,8);
   //ADFS New map - Sector is an indirect address (fragment and sector)
   if Image.MapType=$01 then
    location:='Indirect address: 0x'+IntToHex(Image.RootAddress,8);
   lb_location.Caption:=location;
  end;
 end;
end;

{------------------------------------------------------------------------------}
//Called when the TreeView is updated, and it wants to know which icon to use
{------------------------------------------------------------------------------}
procedure TMainForm.DirListGetImageIndex(Sender: TObject; Node: TTreeNode);
var
 ft,i,dir,entry: Integer;
 filetype      : AnsiString;
begin
 //The directory and entry references, as always
 dir  :=TMyTreeNode(Node).Dir;
 entry:=Node.Index;
 //Are we ADFS?
 if (Image.FormatNumber>=$10) and (Image.FormatNumber<=$1F) then
 begin
  //Default is a file with load and exec address
  ft:=loadexec;
  //If it is not a directory
  if not TMyTreeNode(Node).IsDir then
  begin
   //And has a timestamp
   if Image.Disc[dir].Entries[entry].TimeStamp>0 then
   begin
    //Then we become an unknown filetype, until found that is
    ft:=unknown;
    //Start of search - the filetype constant array
    i:=Low(FileTypes)-1;
    //The filetype of the file
    filetype:=Image.Disc[dir].Entries[entry].ShortFiletype;
    //Just iterate through until we find a match, or get to the end
    repeat
     inc(i)
    until (filetype=FileTypes[i])
      or (i=High(FileTypes));
    //Do we have a match? Make a note
    if filetype=FileTypes[i] then ft:=i;
   end;
  end;
 end
 else
  //Is it a Commodore format?
  if (Image.FormatNumber>=$20) and (Image.FormatNumber<=$2F) then
  begin
   //Default is a PRG file
   ft:=prgfile;
   //Directory has a different icon
   if not TMyTreeNode(Node).IsDir then
   begin
    //Get the appropriate filetype - no array for this as there is only 5 of them
    if Image.Disc[dir].Entries[entry].ShortFileType='SEQ' then ft:=seqfile;
    if Image.Disc[dir].Entries[entry].ShortFileType='USR' then ft:=usrfile;
    if Image.Disc[dir].Entries[entry].ShortFileType='REL' then ft:=relfile;
    if Image.Disc[dir].Entries[entry].ShortFileType='DEL' then ft:=delfile;
    if Image.Disc[dir].Entries[entry].ShortFileType='CBM' then ft:=cbmfile;
   end;
  end
  else
   //If not ADFS or Commodore, use a default icon
   ft:=nonadfs; //(which is actually from ADFS in RISC OS 3.11!!)
 //Diectory icons
 if TMyTreeNode(Node).IsDir then
 begin
  //Different icon if it is expanded, i.e. open
  if Node.Expanded then
   ft:=directory_o
  else
   //to a closed one
   ft:=directory;
  //If RISC OS, and an application
  if Image.FormatNumber shr 4=1 then //ADFS only
   if(Image.DirectoryType=1)OR(Image.DirectoryType=2)then //New or Big
    if Node.Text[1]='!' then ft:=appicon;
 end;
 //Tell the system what the ImageList reference is
 Node.ImageIndex:=ft;
 //And ensure it stays selected
 Node.SelectedIndex:=Node.ImageIndex;
end;

{------------------------------------------------------------------------------}
//Form is getting resized
{------------------------------------------------------------------------------}
procedure TMainForm.FormResize(Sender: TObject);
begin
 if Height<634 then Height:=634; //Minimum height
 if Width<664  then Width:=664; //Minimum width
end;

{------------------------------------------------------------------------------}
//Initialise Form
{------------------------------------------------------------------------------}
procedure TMainForm.FormShow(Sender: TObject);
var
 i: Integer;
begin
 //Initial width and height of form
 Width:=1042;
 Height:=751;
 //Enable or disable buttons
 DisableControls;
 //Reset the file details panel
 ResetFileFields;
 //Clear the search fields
 ResetSearchFields;
 //Clear the status bar
 UpdateImageInfo;
 //Reset the tracking variables
 PathBeforeEdit           :='';
 NameBeforeEdit           :='';
 //There are some commands
 if ParamCount>0 then
 begin
  //Parse each one
  for i:=1 to ParamCount do ParseCommandLine(ParamStr(i));
  //Save and close the application as there are commands
  if HasChanged then
  begin
   Image.SaveToFile(Image.Filename);
   HasChanged:=False;
  end;
  MainForm.Close;
 end;
end;

{------------------------------------------------------------------------------}
//Disable/Enable all the controls for initialisation
{------------------------------------------------------------------------------}
procedure TMainForm.DisableControls;
begin
 //Enable or disable buttons
 btn_NewImage.Enabled     :=True;
 btn_OpenImage.Enabled    :=True;
 btn_SaveImage.Enabled    :=False;
 btn_CloseImage.Enabled   :=False;
 btn_ImageDetails.Enabled :=False;
 btn_About.Enabled        :=True;
 btn_download.Enabled     :=False;
 btn_Delete.Enabled       :=False;
 btn_Rename.Enabled       :=False;
 btn_AddFiles.Enabled     :=False;
 btn_NewDirectory.Enabled :=False;
 //Pop up Menu items
 ExtractFile1.Enabled     :=False;
 RenameFile1.Enabled      :=False;
 DeleteFile1.Enabled      :=False;
 AddFile1.Enabled         :=False;
 NewDirectory1.Enabled    :=False;
 //Main Menu items
 menuNewImage.Enabled     :=True;
 menuOpenImage.Enabled    :=True;
 menuSaveImage.Enabled    :=False;
 menuCloseImage.Enabled   :=False;
 menuImageDetails.Enabled :=False;
 menuExtractFile.Enabled  :=False;
 menuRenameFile.Enabled   :=False;
 menuDeleteFile.Enabled   :=False;
 menuAddFile.Enabled      :=False;
 menuNewDir.Enabled       :=False;
 menuAbout.Enabled        :=True;
 //Disable the search area
 ed_filenamesearch.Enabled:=False;
 ed_lengthsearch.Enabled  :=False;
 ed_filetypesearch.Enabled:=False;
 lb_searchresults.Enabled :=False;
 sb_search.Enabled        :=False;
 //Disable the directory view
 DirList.Enabled          :=False;
 //Reset the changed variable
 HasChanged               :=False;
end;

{------------------------------------------------------------------------------}
//Parse any command line options
{------------------------------------------------------------------------------}
procedure TMainForm.ParseCommandLine(cmd: AnsiString);
var
 index  : Integer;
 option,
 param,
 param2 : AnsiString;
 Dir    : TSearchRec;
 F      : TFileStream;
const DiscFormats = //Accepted format strings
 'DFSS    DFSS40  DFSD    DFSD40  WDFSS   WDFSS40 WDFSD   WDFSD40 ADFSS   ADFSM   '+
 'ADFSL   ADFSD   ADFSE   ADFSE+  ADFSF   ADFSF+  C1541   C1571   C1581   AMIGADD '+
 'AMIGAHD ';
 const DiscNumber : array[1..21] of Integer = //Accepted format numbers
 ($001   ,$000   ,$011   ,$010   ,$021   ,$020   ,$031   ,$030   ,$100   ,$110,
  $120   ,$130   ,$140   ,$150   ,$160   ,$170   ,$200   ,$210   ,$220   ,$400,
  $410);
begin
 //Collate the parameters
 option:=cmd;
 param :='';
 param2:='';
 //Split the parameter into command and attribute
 if Pos(':',option)>1 then
 begin
  param :=RightStr(option,Length(option)-Pos(':',option));
  option:=LowerCase(LeftStr (option,Pos(':',option)-1));
 end;
 if param<>'' then
 begin
  //Remove any quotes from the second parameter
  if (param[1]='"')and(param[Length(param)]='"') then
   param:=Copy(param,2,Length(param)-2);
  //Is there a second paramter?
  if(Pos('"|"',param)>1)and(Pos('"|"',param)<Length(param)-3)then
  begin
   param2:=Copy(param,Pos('"|"',param)+3);   //Get the right most part
   param :=LeftStr(param,Pos('"|"',param)-1);//Get the left most part
  end else
  if(Pos('|',param)>1)and(Pos('|',param)<Length(param)-1)then
  begin
   param2:=Copy(param,Pos('|',param)+1);   //Get the right most part
   param :=LeftStr(param,Pos('|',param)-1);//Get the left most part
  end;
  //Commands that require at least one parameter -------------------------------
  //Run commands from file command
  if (option='--cmdfile') or (option='-f') then
  begin
   try
    F:=TFileStream.Create(param,fmOpenRead OR fmShareDenyNone);
    F.Position:=0;
    while ReadLine(F,option) do ParseCommandLine(option);
    F.Free;
   finally
    // Runs after the above, even if an error occurs
   end;
  end;
  //Open command +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  if (option='--insert') or (option='-i') then
   OpenImage(param);
  //New Image command ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  if (option='--new') or (option='-n') then
  begin
   index:=(Pos(UpperCase(param),DiscFormats) DIV 8)+1;
   //Create new image
   if Image.Format(DiscNumber[index] DIV $100,
                  (DiscNumber[index] DIV $10)MOD $10,
                   DiscNumber[index] MOD $10) then
   begin
    HasChanged:=True;
    ShowNewImage(Image.Filename);
   end;
  end;
  //Commands that require at least one parameter and an image ------------------
  if Image.FormatNumber<>$FF then
  begin
   //Add new file command +++++++++++++++++++++++++++++++++++++++++++++++++++++++
   if (option='--add') or (option='-a') then
   begin
    //Select destination directory
    if param2<>'' then
     SelectNode(param2);
    //param can contain a wild card
    FindFirst(param,faDirectory,Dir);
    repeat
     if (Dir.Name<>'.') and (Dir.Name<>'..') then //These are previous and top directories
     begin //Add a directory and the contents
      if (Dir.Attr AND faDirectory)=faDirectory then
       AddDirectoryToImage(ExtractFilePath(param)+Dir.Name)
      else //Add a single file
       AddFileToImage(ExtractFilePath(param)+Dir.Name);
     end;
    until FindNext(Dir)<>0;
    FindClose(Dir);
   end;
   //Update title for side 0 ++++++++++++++++++++++++++++++++++++++++++++++++++++
   if (option='--title') or (option='-t') then
    Image.UpdateDiscTitle(param,0);
   //Update title for side 1 ++++++++++++++++++++++++++++++++++++++++++++++++++++
   if (option='--title1') or (option='-t1') then
    if Length(Image.Disc)>1 then
     Image.UpdateDiscTitle(param,1);
   //Update boot option for side 0 ++++++++++++++++++++++++++++++++++++++++++++++
   if (option='--opt') or (option='-o') then
   begin
    if LowerCase(param)='none' then param:='0';
    if LowerCase(param)='load' then param:='1';
    if LowerCase(param)='run'  then param:='2';
    if LowerCase(param)='exec' then param:='3';
    Image.UpdateBootOption(StrToIntDef(param,0)mod$10,0);
   end;
   //Update boot option for side 1 ++++++++++++++++++++++++++++++++++++++++++++++
   if (option='--opt1') or (option='-o1') then
    if Length(Image.Disc)>1 then
    begin
     if LowerCase(param)='none' then param:='0';
     if LowerCase(param)='load' then param:='1';
     if LowerCase(param)='run'  then param:='2';
     if LowerCase(param)='exec' then param:='3';
     Image.UpdateBootOption(StrToIntDef(param,0)mod$10,1);
    end;
   //Delete selected file +++++++++++++++++++++++++++++++++++++++++++++++++++++++
   if (option='--delete') or (option='-d') then
   begin
    //Select the file
    SelectNode(param);
    //Now delete it - no confirmations
    DeleteFile(false);
   end;
   //Extract files ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   if (option='--extract') or (option='-e') then
   begin
    //Select the file
    SelectNode(param);
   end;
   //Commands that require a second parameter -----------------------------------
   if param2<>'' then
   begin
    //Rename selected file ++++++++++++++++++++++++++++++++++++++++++++++++++++++
    if (option='--rename') or (option='-r') then
     //Rename the file. If it fails, it will return false.
     HasChanged:=(HasChanged)OR(Image.RenameFile(param,param2)>=0);
   end;
  end;
 end;
 //Commands that do not require any parameters ---------------------------------
 //Create a new directory under selected directory (ADFS/Amiga) ++++++++++++++++
 if (option='--create') or (option='-c') then
 begin
  //Select the parent, if one is specified
  if param2<>'' then SelectNode(param2);
  //Then create the directory
  if param='' then param:='NewDir'; //Default name, if none supplied
  if CreateDirectory(param,'DLR')<>nil then HasChanged:=True;
 end;
 //Save image ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 if (option='--save') or (option='-s') then
  if Image.FormatNumber<>$FF then
  begin
   if param='' then param:=Image.Filename;
   Image.SaveToFile(param);
   Caption:=ApplicationTitle+' - '+ExtractFileName(Image.Filename);
   HasChanged:=False;
   //Update the status bar
   UpdateImageInfo
  end;
end;

{------------------------------------------------------------------------------}
//This is called when the form is created - i.e. when the application is created
{------------------------------------------------------------------------------}
procedure TMainForm.FormCreate(Sender: TObject);
begin
 //Just updates the title bar
 Caption:=ApplicationTitle;
 //Create the image instance
 Image:=TDiscImage.Create;
 //Used for dragging and dropping
 imgCopy.Parent:=DirList;
end;

{------------------------------------------------------------------------------}
//Highlight the file in the tree
{------------------------------------------------------------------------------}
procedure TMainForm.lb_searchresultsClick(Sender: TObject);
var
 i,s : Integer;
begin
 //Selected item: -1 for none
 s:=-1;
 //Find the selected item
 for i:=0 to lb_searchresults.Items.Count-1 do
  if lb_searchresults.Selected[i] then s:=i;
 //Found? So highlight it
 if s>=0 then
 begin
  SelectNode(lb_searchresults.Items[s]);
  lb_searchresults.Selected[s]:=False; //Deselect in the search window
 end;
end;

{------------------------------------------------------------------------------}
//Select a node
{------------------------------------------------------------------------------}
procedure TMainForm.SelectNode(filename: AnsiString);
var
 entry,
 dir,i : Integer;
 ptr   : Cardinal;
begin
 //First, get the reference
 Image.FileExists(filename,ptr);
 entry:=ptr mod $10000;  //Bottom 16 bits - entry reference
 dir  :=ptr div $10000;  //Top 16 bits - directory reference
 //Then find the node
 for i:=0 to DirList.Items.Count-1 do
  if  (TMyTreeNode(DirList.Items[i]).Dir=dir)
  and (DirList.Items[i].Index=entry) then
   //and select it
   DirList.Items[i].Selected:=True;
 //We'll need to give the tree focus, so it shows up
 DirList.SetFocus;
end;

{------------------------------------------------------------------------------}
//This just creates our custom TTreeNode
{------------------------------------------------------------------------------}
procedure TMainForm.DirListCreateNodeClass(Sender: TCustomTreeView;
  var NodeClass: TTreeNodeClass);
begin
  NodeClass:=TMyTreeNode;
end;

{------------------------------------------------------------------------------}
//Save the Image to disc
{------------------------------------------------------------------------------}
procedure TMainForm.btn_SaveImageClick(Sender: TObject);
var
 ext,
 filename: AnsiString;
begin
 //Remove the existing part of the original filename
 filename:=ExtractFileName(Image.Filename);
 ext:=ExtractFileExt(filename);
 filename:=LeftStr(filename,Length(filename)-Length(ext));
 //Populate the filename part of the dialogue
 SaveImage.FileName:=filename+'.'+Image.FormatExt;
 SaveImage.DefaultExt:=Image.FormatExt;
 //Show the dialogue
 If SaveImage.Execute then
 begin
  //Save the image
  Image.SaveToFile(SaveImage.FileName);
  Caption:=ApplicationTitle+' - '+ExtractFileName(Image.Filename);
  HasChanged:=False;
  //Update the status bar
  UpdateImageInfo
 end;
end;

{------------------------------------------------------------------------------}
//Query about unsaved changes
{------------------------------------------------------------------------------}
function TMainForm.QueryUnsaved: Boolean;
begin
 Result:=True;
 if HasChanged then
  Result:=MessageDlg('You have unsaved changes. Do you wish to continue?',
                mtInformation,[mbYes,mbNo],0)=mrYes;
end;

{------------------------------------------------------------------------------}
//Application is asking whether it can close
{------------------------------------------------------------------------------}
procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
 CanClose:=QueryUnsaved;
end;

{------------------------------------------------------------------------------}
//Open an image or add a new file to the disc image, by drag and dropping
{------------------------------------------------------------------------------}
procedure TMainForm.FormDropFiles(Sender: TObject;
 const FileNames: array of AnsiString);
var
 FileName: AnsiString;
begin
 for FileName in FileNames do
 begin
  if not DirectoryExists(Filename) then
   if Image.Filename='' then //Nothing is loaded, so initiate load
    OpenImage(FileName)
   else //Otherwise, add the file to the image, under the selected directory
    AddFileToImage(FileName) //This will try and add image files to an image
  else //Bulk add from a directory
   AddDirectoryToImage(FileName);
 end;
end;

{------------------------------------------------------------------------------}
//User has clicked on directory title
{------------------------------------------------------------------------------}
procedure TMainForm.lb_titleClick(Sender: TObject);
begin
 //If there is only one selection
 if DirList.SelectionCount=1 then
  //And it is a directory
  if TMyTreeNode(DirList.Selected).IsDir then
   //And the editor is enabled
   if ed_title.Enabled then
   begin //Then show it, with the title text
    ed_title.Visible  :=True;
    ed_title.Text     :=lb_title.Caption;
    ed_title.SetFocus; //Put the cursor in the control
    lb_title.Visible  :=False;
   end;
end;

{------------------------------------------------------------------------------}
//User has done editing directory title
{------------------------------------------------------------------------------}
procedure TMainForm.ed_titleEditingDone(Sender: TObject);
var
 filename,
 newtitle  : AnsiString;
begin
 //Get the filename of the directory being edited
 filename:=lb_Filename.Caption;
 //Add the path, if there is one
 if lb_Parent.Caption<>'' then
  filename:=lb_Parent.Caption+Image.DirSep+filename;
 //Then send to be retitled
 newtitle:=ed_title.Text;
 if Image.RetitleDirectory(filename,newtitle) then
 begin
  lb_title.Caption:=newtitle; //If success, then change the text
  HasChanged:=True;
 end;
 lb_title.Visible:=True;
 ed_title.Visible:=False;
end;

{------------------------------------------------------------------------------}
//Image Detail Display
{------------------------------------------------------------------------------}
procedure TMainForm.btn_ImageDetailsClick(Sender: TObject);
var
 t,s,side  : Integer;
 col       : TColor;
 FSM       : array of TImage;
 FSMlabel  : array of TLabel;
 titles    : array[0..1] of TEdit;
 boots     : array[0..1] of TComboBox;
 bootlbs   : array[0..1] of TLabel;
 title     : AnsiString;
 numsides,
 size      : Byte;
begin
 size:=8; //Pixel size
 //Add the editable controls to arrays - makes it easier later on
 titles[0] :=ImageDetailForm.edDiscTitle0;
 titles[1] :=ImageDetailForm.edDiscTitle1;
 boots[0]  :=ImageDetailForm.cbBootOption0;
 boots[1]  :=ImageDetailForm.cbBootOption1;
 bootlbs[0]:=ImageDetailForm.lbBootOption0;
 bootlbs[1]:=ImageDetailForm.lbBootOption1;
 //CRC32
 ImageDetailForm.lbCRC32.Caption:=Image.CRC32;
 //How many sides
 numsides:=Length(Image.FreeSpaceMap);
 //Show the Free Space Map graphic
 if numsides>0 then //Is there a free space map?
 begin
  //Setup the TImage array for all sides
  SetLength(FSM,numsides);
  SetLength(FSMlabel,numsides);
  for side:=0 to numsides-1 do
  begin
   //Create the image and give it a parent
   FSM[side]:=TImage.Create(ImageDetailForm);
   FSM[side].Parent:=ImageDetailForm;
   //FSM[side].Canvas.PixelFormat:=pf4bit;
   //Position it
   FSM[side].Top:=20;
   FSM[side].Left:=4+(204*side);
   //Create the image label and give it a parent
   FSMlabel[side]:=TLabel.Create(ImageDetailForm);
   FSMlabel[side].Parent:=ImageDetailForm;
   //Position it
   FSMlabel[side].Top:=0;
   FSMlabel[side].Left:=4+(204*side);
   //We'll stretch it later
   FSM[side].Stretch:=False;
   //Set the initial size
   while (size>1) AND (Length(Image.FreeSpaceMap[0])*size>100000) do dec(size);
   t:=Length(Image.FreeSpaceMap[0])*size;
   s:=Length(Image.FreeSpaceMap[0,0])*size;
   FSM[side].Height:=t;//Length(Image.FreeSpaceMap[0])*size;
   FSM[side].Width:=s;//Length(Image.FreeSpaceMap[0,0])*size;
   //Now draw all the sectors in tracks
   for t:=0 to Length(Image.FreeSpaceMap[side])-1 do
    for s:=0 to Length(Image.FreeSpaceMap[side,t])-1 do
    begin
     //Colour for free space
     col:=ImageDetailForm.colFree.Brush.Color;
     //Other colours
     if Image.FreeSpaceMap[side,t,s]=$FF then
      col:=ImageDetailForm.colFile.Brush.Color;      //Unknown/Files
     if Image.FreeSpaceMap[side,t,s]=$FE then
      col:=ImageDetailForm.colSystem.Brush.Color;    //System
     if Image.FreeSpaceMap[side,t,s]=$FD then
      col:=ImageDetailForm.colDir.Brush.Color;       //Directories
     //Change the canvas colour
     FSM[side].Canvas.Pen.Color:=col;
     FSM[side].Canvas.Brush.Color:=col;
     //Now draw a rectangle to represent the sector
     FSM[side].Canvas.Rectangle(s*size,t*size,(s+1)*size,(t+1)*size);
    end;
   //Stretch the image
   FSM[side].Stretch:=True;
   //And resize to fit the window
   FSM[side].Height:=ImageDetailForm.ClientHeight-24;
   FSM[side].Width:=200;
   //Set the label size
   FSMlabel[side].Height:=20;
   FSMlabel[side].Width:=200;
   FSMlabel[side].Alignment:=taCenter;
   FSMlabel[side].AutoSize:=False;
   //And fill in the details
   FSMlabel[side].Font.Style:=[fsBold];
   FSMlabel[side].Caption:='Free Space Map Side '+IntToStr(side);
   //Disc Title
   if Image.FormatNumber shr 4=0 then title:=Image.Disc[side].Title
   else title:=Image.Title;
   //Remove top bit - this can cause havoc with Mac OS
   RemoveTopBit(title);
   //Set the edit box
   titles[side].Text:=title;
   titles[0].Enabled:=True;
   //Limit the length
   if Image.FormatNumber shr 4=0 then titles[0].MaxLength:=12; //DFS
   if Image.FormatNumber shr 4=1 then titles[0].MaxLength:=10; //ADFS
   //Boot Option
   boots[side].Visible  :=True;
   if Length(Image.BootOpt)>0 then
    boots[side].ItemIndex:=Image.BootOpt[side]
   else
    boots[side].Visible:=False;
   bootlbs[side].Visible:=boots[side].Visible;
   end;
  //Change the dialogue box width
  ImageDetailForm.ClientWidth:=(Length(Image.FreeSpaceMap)*204)
                              +4+ImageDetailForm.Legend.Width;
  //Show/Hide the second detail panel
  ImageDetailForm.pnSide1.Visible:=numsides>1;
  //Show the window, modally
  if ImageDetailForm.ShowModal=mrOK then
  begin
   for side:=0 to numsides-1 do
   begin
    //Update Disc Title
    if Image.UpdateDiscTitle(titles[side].Text,side) then
     HasChanged:=True;
    //Update Boot Option
    if Image.UpdateBootOption(boots[side].ItemIndex,side) then
     HasChanged:=True;
   end;
   UpdateImageInfo;
  end;
  //Clear up and close
  for side:=0 to numsides-1 do
  begin
   FSM[side].Free;
   FSMlabel[side].Free;
  end;
 end;
end;

{------------------------------------------------------------------------------}
//Close currently open image
{------------------------------------------------------------------------------}
procedure TMainForm.btn_CloseImageClick(Sender: TObject);
begin
 if QueryUnsaved then
 begin
  Image.Close;
  ShowNewImage('');
  UpdateImageInfo;
  DisableControls;
 end;
end;

{------------------------------------------------------------------------------}
//Create a new directory click
{------------------------------------------------------------------------------}
procedure TMainForm.btn_NewDirectoryClick(Sender: TObject);
var
 dirname,
 parentdir : AnsiString;
 x         : Integer;
 ref       : Cardinal;
begin
 //Assume the root, for now
 parentdir:='$';
 if DirList.Selected.Text<>'$' then //If not the root, get the parent directory
  parentdir:=GetImageFilename(TMyTreeNode(DirList.Selected).Dir,
                                          DirList.Selected.Index);
 //Default name
 dirname:='NewDir';
 //Make sure it doesn't exist
 x:=0;
 while Image.FileExists(parentdir+Image.DirSep+dirname+IntToStr(x),ref) do
  inc(x);
 dirname:=dirname+IntToStr(x);
 //Create the directory
 CreateDirectory(dirname,'DLR');
end;

{------------------------------------------------------------------------------}
//Create a new directory
{------------------------------------------------------------------------------}
function TMainForm.CreateDirectory(dirname, attr: AnsiString): TTreeNode;
var
 parentdir: AnsiString;
 index    : Integer;
 Node     : TTreeNode;
begin
 Result:=nil;
 //Assume the root, for now
 parentdir:='$';
 if DirList.Selected.Text<>'$' then //If not the root, get the parent directory
  parentdir:=GetImageFilename(TMyTreeNode(DirList.Selected).Dir,
                                          DirList.Selected.Index);
 //Add it
 index:=Image.CreateDirectory(dirname,parentdir,attr);
 //Function returns pointer to next item (or parent if no children)
 if index>-1 then //Directory added OK
 begin
  Node:=AddFileToTree(DirList.Selected,dirname,index,True);
  //Select the new node
  DirList.ClearSelection;
  Node.Selected:=True;
  //Return the newly created directory as a node
  Result:=Node;
 end
  else
  begin//For some reason the operation failed to write the data
   if index=-1 then ReportError('Cannot create a directory on this platform');
   if index=-2 then ReportError('Could not add directory - image full');
   if index=-3 then ReportError('Directory already exists in image');
   if index=-4 then ReportError('Catalogue full');
   if index=-5 then ReportError('Could not write directory - error unknown');
   if index=-6 then ReportError('Destination directory does not exist');
   If index=-7 then ReportError('Could not write directory - map full');
   if index=-8 then ReportError('Could not write directory - nothing to write');
  end;
end;

{------------------------------------------------------------------------------}
//User has initiated a drag operation on the directory list
{------------------------------------------------------------------------------}
procedure TMainForm.DirListMouseDown(Sender: TObject; Button: TMouseButton;
 Shift: TShiftState; X, Y: Integer);
begin
 //ADFS, double sided DFS, or AmigaDOS
 if((Image.FormatNumber shr 4=0) AND (Image.DoubleSided))
 or (Image.FormatNumber shr 4=1)
 or (Image.FormatNumber shr 4=4) then
 begin
  //Remember the node being dragged
  DraggedItem:=DirList.GetNodeAt(X,Y);
  //If it is valid
  if DraggedItem<>nil then
  begin
   //Set the mouse down flag
   MouseIsDown :=True;
   //Remember the mouse position
   CursorPos.X:=X;
   CursorPos.Y:=Y;
  end;
 end;
end;

{------------------------------------------------------------------------------}
//Mouse Move event handler for the 'ghost' image
{------------------------------------------------------------------------------}
procedure TMainForm.DraggedItemMouseMove(Sender: TObject; Shift: TShiftState; X,
 Y: Integer);
begin
 //Adjust the X and Y and pass through to the DirList event handler
 DirListMouseMove(Sender,Shift,X+ObjectDrag.Left,Y+ObjectDrag.Top);
end;

{------------------------------------------------------------------------------}
//Mouse Up event handler for the 'ghost' image
{------------------------------------------------------------------------------}
procedure TMainForm.DraggedItemMouseUp(Sender: TObject; Button: TMouseButton;
 Shift: TShiftState; X, Y: Integer);
begin
 //Adjust the X and Y and pass through to the DirList event handler
 DirListMouseUp(Sender,Button,Shift,X+ObjectDrag.Left,Y+ObjectDrag.Top);
end;

{------------------------------------------------------------------------------}
//User has dragged an item around the directory list
{------------------------------------------------------------------------------}
procedure TMainForm.DirListMouseMove(Sender: TObject; Shift: TShiftState; X,
 Y: Integer);
var
 Xmovement,
 Ymovement,
 H         : Integer;
 R         : TRect;
 B         : TBitmap;
 Dst       : TTreeNode;
 copymode  : Boolean;
begin
 copymode:=GetCopyMode(Shift);
 //Is the mouse button down?
 if MouseIsDown then
 begin
  //Work out how far the mouse has moved
  Xmovement:=Abs(X-CursorPos.X);
  Ymovement:=Abs(Y-CursorPos.Y);
  //If it has moved more than 10 pixels then user is dragging
  if(Xmovement>10)or(Ymovement>10)then
  begin
   //We are dragging the control
   IsDragging:=True;
   //Are we over another node?
   Dst:=DirList.GetNodeAt(X,Y);
   if(DraggedItem<>nil)AND(Dst<>nil)AND(DraggedItem<>Dst) then
   begin
    //If it is not a directory, then get the parent
    if not TMyTreeNode(Dst).IsDir then
     Dst:=Dst.Parent;
    //Only allow copying if it is a different parent and not within itself
    if(DraggedItem<>Dst)AND(DraggedItem.Parent<>Dst)then
    begin
     //Highlight it, keeping the original highlighted
     DirList.ClearSelection;
     DraggedItem.Selected:=True;
     Dst.Selected:=True;
     //Expand the folder tree
     Dst.Expand(False);
    end;
   end;
   //See if we have created an image to move, if not then do so
   if ObjectDrag=nil then
   begin
    //Get the bounding box of the dragged item
    R:=DraggedItem.DisplayRect(False);
    //Now create a bitmap copy of this
    B:=TBitmap.Create;
    B.Width:=R.Width;
    B.Height:=R.Height;
    //We need it transparent
    B.Transparent:=True;
    B.TransparentColor:=clFuchsia;
    B.Canvas.Brush.Color:=clFuchsia;
    B.Canvas.FillRect(Rect(0,0,R.Width,R.Height));
    //Put the file icon in
    FileImages.Draw(B.Canvas,1,0,DraggedItem.ImageIndex);
    //Set up the font
    B.Canvas.Font:=DirList.Font;
    B.Canvas.Font.Quality:=fqNonAntialiased; //Otherwise we get a purple 'shadow'
    B.Canvas.Font.Style:=[fsBold];
    //Centralise the text
    H:=B.Canvas.TextHeight(DraggedItem.Text);
    B.Canvas.TextOut(Fileimages.Width+8,
                    (Fileimages.Height-H)div 2,
                     DraggedItem.Text);
    //Now create the new image
    ObjectDrag:=TImage.Create(DirList);
    ObjectDrag.Parent:=DirList;
    //Assign the mouse move event handler
    ObjectDrag.OnMouseMove:=@DraggedItemMouseMove;
    ObjectDrag.OnMouseUp:=@DraggedItemMouseUp;
    //Set the size
    ObjectDrag.Width:=B.Width;
    ObjectDrag.Height:=B.Height;
    //Put our bitmap in
    ObjectDrag.Picture.Assign(B);
    ObjectDrag.Transparent:=True;
    //Make sure we can see it
    ObjectDrag.Visible:=True;
    //And free up the bitmap
    B.Free;
   end;
   //Position our copied control above the mouse
   ObjectDrag.Top:=Y-(ObjectDrag.Height div 2);
   ObjectDrag.Left:=X-(Fileimages.Width+4);
   //Show and position the 'copy' plus icon
   imgCopy.Visible:=copymode;
   imgCopy.Top:=Y+8;
   imgCopy.Left:=X+8;
   //Scroll the control, if near the edge - looks like can't be done easily
  end;
 end;
end;

{------------------------------------------------------------------------------}
//Determine whether to copy or move
{------------------------------------------------------------------------------}
function TMainForm.GetCopyMode(Shift: TShiftState): Boolean;
begin
 //Default result
 Result:=True;
 //Look at the key modifiers
 {$IFDEF Darwin}   //For the Mac
 if ssMeta in Shift then Result:=False; //Move
 if ssAlt in Shift  then Result:=True;  //Copy
 {$ELSE}           //For Windows or Linux
 if ssShift in Shift then Result:=False; //Move
 if ssCtrl in Shift  then Result:=True;  //Copy
 {$ENDIF}
end;

{------------------------------------------------------------------------------}
//User has dropped an item over the directory list
{------------------------------------------------------------------------------}
procedure TMainForm.DirListMouseUp(Sender: TObject; Button: TMouseButton;
 Shift: TShiftState; X, Y: Integer);
var
 Xmovement,
 Ymovement,
 index      : Integer;
 Dst        : TTreeNode;
 copymode   : Boolean;
begin
 copymode:=GetCopyMode(Shift);
 //Remove the copied control
 if ObjectDrag<>nil then ObjectDrag.Free;
 ObjectDrag:=nil;
 //And hide the 'copy' plus icon
 imgCopy.Visible:=False;
 //If we are in dragging mode, and the mouse is down
 if(MouseIsDown)and(IsDragging)then
 begin
  //Work out how far the mouse has moved
  Xmovement:=Abs(X-CursorPos.X);
  Ymovement:=Abs(Y-CursorPos.Y);
  //If it has moved more than 10 pixels then user is dragging
  if(Xmovement>10)or(Ymovement>10)then
  begin
   //Are we over another node?
   Dst:=DirList.GetNodeAt(X,Y);
   if(DraggedItem<>nil)AND(Dst<>nil)AND(DraggedItem<>Dst) then
   begin
    //If it is not a directory, then get the parent
    if not TMyTreeNode(Dst).IsDir then
     Dst:=Dst.Parent;
    //Only allow copying if it is a different parent and not within itself
    if(DraggedItem<>Dst)AND(DraggedItem.Parent<>Dst)then
    begin
     //Currently only files - this needs to be written.
     if TMyTreeNode(DraggedItem).IsDir then
      ReportError('The functionality to copy/move directories has not yet been written.')
     else
      begin
       //Do the copy/move
       if copymode then
        index:=Image.CopyFile(GetFilePath(DraggedItem),GetFilePath(Dst))
       else
        index:=Image.MoveFile(GetFilePath(DraggedItem),GetFilePath(Dst));
       //Update the display
       if index>=0 then AddFileToTree(Dst,DraggedItem.Text,index,False);
       if index<0 then
       begin
        //For some reason the operation failed to write the data these are the error
        //codes returned when writing a file, as it uses the same function)
        if index=-1 then ReportError('Could not load "'+DraggedItem.Text+'"');
        if index=-2 then ReportError('Could not add file - image full');
        if index=-3 then ReportError('File already exists in directory');
        if index=-4 then ReportError('Catalogue full');
        if index=-5 then ReportError('Could not write file - error unknown');
        if index=-6 then ReportError('Destination directory does not exist');
        If index=-7 then ReportError('Could not write file - map full');
        if index=-8 then ReportError('Could not write file - nothing to write');
        if index=-9 then ReportError('Cannot move or copy to the same directory');
       end;
      end;
    end;
   end;
  end;
  //Clear any selections
  if DraggedItem<>nil then
  begin
   DirList.ClearSelection;
   //But make sure ours is still selected
   DraggedItem.Selected:=True;
   //Flush the memory of what is being dragged
   DraggedItem:=nil;
  end;              
 end;
  //Reset the flags
  MouseIsDown:=False;
  IsDragging:=False;
end;

{------------------------------------------------------------------------------}
//Create a new blank image
{------------------------------------------------------------------------------}
procedure TMainForm.btn_NewImageClick(Sender: TObject);
var
 minor,tracks: Byte;
begin
 if QueryUnsaved then
 begin
  //Show the form, modally
  NewImageForm.ShowModal;
  //If Create was clicked, then create a new image
  if NewImageForm.ModalResult=mrOK then
  begin
   //Get the sub-format
   minor:=$F;
   case NewImageForm.MainFormat.ItemIndex of
    0: minor:=NewImageForm.DFS.ItemIndex;
    1: minor:=NewImageForm.ADFS.ItemIndex;
    2: minor:=NewImageForm.C64.ItemIndex;
    3: minor:=NewImageForm.Spectrum.ItemIndex;
    4: minor:=NewImageForm.Amiga.ItemIndex;
   end;
   //Number of tracks (DFS only)
   tracks:=0; //Default
   if NewImageForm.MainFormat.ItemIndex=0 then
    tracks:=NewImageForm.DFSTracks.ItemIndex;
   //Now create the image
   if Image.Format(NewImageForm.MainFormat.ItemIndex,minor,tracks) then
   begin
    HasChanged:=True;
    ShowNewImage(Image.Filename);  //This updates the status bar
   end
   else
    ReportError('Failed to create image');
  end;
 end;
end;

{------------------------------------------------------------------------------}
//Attribute has been changed
{------------------------------------------------------------------------------}
procedure TMainForm.AttributeChangeClick(Sender: TObject);
var
 att,filepath: AnsiString;
begin
 if not DoNotUpdate then
 begin
  att:='';
   //Attributes
   if cb_ownerwrite.Checked       then att:=att+'W';
   if cb_ownerread.Checked        then att:=att+'R';
   if cb_ownerlocked.Checked      then att:=att+'L';
   if cb_ownerexecute.Checked     then
    if Image.FormatNumber shr 4=1 then att:=att+'E'
                                  else att:=att+'C';
   if cb_publicwrite.Checked      then att:=att+'w';
   if cb_publicread.Checked       then att:=att+'r';
   if cb_publicexecute.Checked    then att:=att+'e';
   if cb_private.Checked          then att:=att+'P';
   if TMyTreeNode(DirList.Selected).IsDir then att:=att+'D';
   //Get the file path
   filepath:=GetFilePath(DirList.Selected);
   //Update the attributes for the file
   if Image.UpdateAttributes(filepath,att) then
   begin
    HasChanged:=True;
    //Update the status bar
    UpdateImageInfo
   end
   else
   begin
    //If unsuccessful, revert back.
    DoNotUpdate:=True;
    TCheckbox(Sender).Checked:=not TCheckbox(Sender).Checked;
    DoNotUpdate:=False;
   end;
 end;
end;

{------------------------------------------------------------------------------}
//Get full file path from selected node
{------------------------------------------------------------------------------}
function TMainForm.GetFilePath(Node: TTreeNode): AnsiString;
begin
 //Make sure that the node exists
 if Node<>nil then
 begin
  //Start with the text in the node (i.e the filename)
  Result:=Node.Text;
  //If it has a parent, then add this and move up a level, until we reach the root
  while Node.Parent<>nil do
  begin
   Node:=Node.Parent;
   Result:=Node.Text+Image.DirSep+Result;
  end;
 end;
end;

{------------------------------------------------------------------------------}
//Delete file
{------------------------------------------------------------------------------}
procedure TMainForm.DeleteFile1Click(Sender: TObject);
var
 R: Boolean;
begin
 //Result of the confirmation - assumed Yes for now
 R:=True;
 //For mulitple deletes, ensure that the user really wants to
 if DirList.SelectionCount>1 then
   R:=MessageDlg('Delete '+IntToStr(DirList.SelectionCount)+' files?',
                 mtInformation,[mbYes, mbNo],0)=mrYes;
 //If user does, or single file, continue
 if R then DeleteFile(True);
end;

{------------------------------------------------------------------------------}
//Delete selected files
{------------------------------------------------------------------------------}
procedure TMainForm.DeleteFile(confirm: Boolean);
var
 i: Integer;
 R: Boolean;
 filepath: AnsiString;
begin
 //Go through all the selections (or the only one)
 for i:=0 to DirList.SelectionCount-1 do
 begin
  //Get the full path to the file
  filepath:=GetFilePath(DirList.Selections[i]);
  //If singular, check if the user wants to
  if (DirList.SelectionCount=1) and (confirm) then
   R:=MessageDlg('Delete '+filepath+'?',mtInformation,[mbYes, mbNo],0)=mrYes
  else R:=True;
  //If so, then delete
  if R then
   if Image.DeleteFile(filepath) then
   begin
    HasChanged:=True;
    //Update the status bar
    UpdateImageInfo;
    //Now update the node and filedetails panel
    DirList.Selections[i].Delete;
    ResetFileFields;
   end;
 end;
end;

{------------------------------------------------------------------------------}
//User has double clicked on the DirList box
{------------------------------------------------------------------------------}
procedure TMainForm.DirListDblClick(Sender: TObject);
var
 Node: TTreeNode;
begin
 //Get the selected Node (currently only a single node can be selected)
 Node:=DirList.Selected;
 //Only act on it if there is one selected
 if Node<>nil then
  //If it is not a directory, then proceed to download it, otherwise the system
  //will just expand the node
  if not (TMyTreeNode(Node).IsDir) then
   btn_downloadClick(Sender); //Change to open a new window with hex dump inside
end;

{------------------------------------------------------------------------------}
//Rename menu item has been clicked
{------------------------------------------------------------------------------}
procedure TMainForm.RenameFile1Click(Sender: TObject);
begin
 //Make sure we're not dealing with the root
 if DirList.Selected.Parent<>nil then
 begin
  //Save the path and name before they get edited
  PathBeforeEdit:=GetFilePath(DirList.Selected);
  NameBeforeEdit:=DirList.Selected.Text;
  //Set the node to edit mode
  DirList.Selected.EditText;
 end;
end;

{------------------------------------------------------------------------------}
//Can we rename this node or not?
{------------------------------------------------------------------------------}
procedure TMainForm.DirListEditing(Sender: TObject; Node: TTreeNode;
  var AllowEdit: Boolean);
begin
 //Set the node to edit mode, if not the root
 AllowEdit:=Node.Parent<>nil;
 //Save the path and name before they get edited
 PathBeforeEdit:=GetFilePath(Node);
 NameBeforeEdit:=Node.Text;
end;

{------------------------------------------------------------------------------}
//Rename file/directory
{------------------------------------------------------------------------------}
procedure TMainForm.DirListEditingEnd(Sender: TObject; Node: TTreeNode;
 Cancel: Boolean);
var
 newfilename: AnsiString;
 newindex: Integer;
 NewNode: TTreeNode;
begin
 newfilename:=Node.Text;
 if not Cancel then
 begin
  //Rename the file
  newindex:=Image.RenameFile(PathBeforeEdit,newfilename);
  if newindex<0 then
  begin
   //Revert if it cannot be renamed
   Node.Text:=NameBeforeEdit;
   //And report error
   if newindex=-1 then ReportError('Failed to rename file/directory');
   if newindex=-2 then ReportError('File/directory does not exist');
   if newindex=-3 then ReportError('Cannot rename file/directory - "'+newfilename+'" already exists');
   if newindex=-4 then ReportError('Could not extend parent directory - image full');
   if newindex=-5 then ReportError('Could not extend parent directory - no free fragments');
   if newindex=-6 then ReportError('Renaming unsupported in this format');
  end
  else
  begin
   HasChanged:=True;
   //Update the status bar
   UpdateImageInfo;
   //Otherwise change the text on the tree and the file details panel
   Node.Text:=newfilename;
   //We will need to delete the entry, then re-add it, as it may have moved as
   //a result of being renamed.
   if newindex<>Node.Index then
   begin
    //Move up
    while newindex<Node.Index do
    begin
     NewNode:=Node.GetPrevSibling;
     if NewNode<>nil then Node.MoveTo(NewNode,naInsert);
    end;
    //Move down
    while newindex>Node.Index do
    begin
     NewNode:=Node.GetNextSibling;
     if NewNode<>nil then NewNode.MoveTo(Node,naInsert);
    end;
   end;
   //Update the directory list
   DirListChange(Sender,Node);
  end;
 end;
 //Reset the tracking variables
 PathBeforeEdit:='';
 NameBeforeEdit:='';
end;

{------------------------------------------------------------------------------}
//Reset the label fields for file info
{------------------------------------------------------------------------------}
procedure TMainForm.ResetFileFields;
begin
 DoNotUpdate         :=True;
 lb_FileName.Caption :='';
 lb_filetype.Caption :='';
 lb_loadaddr.Caption :='';
 lb_execaddr.Caption :='';
 lb_length.Caption   :='';
 lb_timestamp.Caption:='';
 lb_parent.Caption   :='';
 lb_title.Caption    :='';
 lb_title.Visible    :=True;
 ed_title.Visible    :=False;
 ed_title.Enabled    :=False;
 lb_location.Caption :='';
 lb_CRC32.Caption    :='';
 img_FileType.Picture.Bitmap:=nil;
 //Disable the access tick boxes
 cb_ownerwrite.Visible    :=False;
 cb_ownerread.Visible     :=False;
 cb_ownerlocked.Visible   :=False;
 cb_ownerexecute.Visible  :=False;
 cb_publicwrite.Visible   :=False;
 cb_publicread.Visible    :=False;
 cb_publicexecute.Visible :=False;
 cb_private.Visible       :=False;
 //And untick them
 cb_ownerwrite.Checked    :=False;
 cb_ownerread.Checked     :=False;
 cb_ownerlocked.Checked   :=False;
 cb_ownerexecute.Checked  :=False;
 cb_publicwrite.Checked   :=False;
 cb_publicread.Checked    :=False;
 cb_publicexecute.Checked :=False;
 cb_private.Checked       :=False;
 DoNotUpdate   :=False;
end;

{------------------------------------------------------------------------------}
//Clear the search edit boxes
{------------------------------------------------------------------------------}
procedure TMainForm.ResetSearchFields;
begin
 lb_searchresults.Clear;
 ed_filenamesearch.Text:='';
 ed_lengthsearch.Text:='';
 searchresultscount.Caption:='Number of results found: '+IntToStr(lb_searchresults.Count);
end;

{------------------------------------------------------------------------------}
//Search for files
{------------------------------------------------------------------------------}
procedure TMainForm.sb_searchClick(Sender: TObject);
var
 search : TDirEntry;
 results: TSearchResults;
 i      : Integer;
begin
 ResetDirEntry(search);
 SetLength(results,0);
 //Get the search criteria
 search.Filename:=ed_filenamesearch.Text;
 search.Filetype:=ed_filetypesearch.Text;
 //Validate that the length entered is a hex number or zero if not
 search.Length:=StrToIntDef('$'+ed_lengthsearch.Text,0);
 //Search for files
 results:=Image.FileSearch(search);
 //Clear the results
 lb_searchresults.Clear;
 //Now populate, if there is anything to add to it
 if Length(results)>0 then
  for i:=0 to Length(results)-1 do
   lb_searchresults.Items.Add(results[i].Parent+'.'+results[i].Filename);
 //And report how many results
 searchresultscount.Caption:='Number of results found: '+IntToStr(lb_searchresults.Count);
end;

{------------------------------------------------------------------------------}
//Converts a number into a string with trailing 'Bytes', 'KB', etc.
{------------------------------------------------------------------------------}
function TMainForm.ConvertToKMG(size: Int64): AnsiString;
var
 new_size_int : Int64; //Int64 will allow for huge disc sizes
 new_size_dec,
 level,
 multiplier   : Integer;
const
 sizes: array[1..6] of AnsiString = ('Bytes','KB','MB','GB','TB','EB');
begin
 //Default is in bytes
 Result:=IntToStr(size)+' '+sizes[1];
 //How far through the array
 level:=0;
 //Current multiplier - KB is 1024 bytes, but MB is 1000 KB...odd, I know!
 multiplier:=1024;
 //We just do this as the first thing we do is divide
 new_size_int:=size*multiplier;
 repeat //we could use a While Do loop and avoid the pre-multiplying above
  inc(level); //Next level, or entry into the array
  //There are 1000KB per MB, 1000MB per GB, etc. but 1024 bytes per KB, etc.
  if level>2 then multiplier:=1000;
  //Work out the remainder, as a decimal to three decimal places
  new_size_dec:=Round(((new_size_int mod multiplier)/multiplier)*1000);
  //Reduce the size to the next smaller multiple
  new_size_int:=new_size_int div multiplier;
  //and repeat until we are smaller than the current multiple, or out of choices
 until (new_size_int<multiplier) or (level=High(sizes));
 //If level is valid
 if level<=High(sizes) then
 begin
  //First the major, whole number, portion
  Result:=IntToStr(new_size_int);
  //Then the decimal portion, but only if there is one
  if new_size_dec>0 then
  begin
   //Add an extra zero, which will be removed
   Result:=Result+'.'+IntToStr(new_size_dec)+'0';
   //Now remove all the surplus zeros
   repeat
    Result:=Copy(Result,1,Length(Result)-1);
   until Result[Length(Result)]<>'0';
  end;
  //And finally return the result, with the unit
  Result:=Result+' '+sizes[level];
 end;
end;

{------------------------------------------------------------------------------}
//Converts Int64 to string, adding in the thousand separator ','
{------------------------------------------------------------------------------}
function TMainForm.IntToStrComma(size: Int64): AnsiString;
begin
 Result:=Format('%.0n',[1.0*size]);
end;

{------------------------------------------------------------------------------}
//Custom redraw event for the status bar
{------------------------------------------------------------------------------}
procedure TMainForm.ImageDetailsDrawPanel(StatusBar: TStatusBar;
 Panel: TStatusPanel; const Rect: TRect);
var
 png: Byte;
begin
 //First panel - we want to put the 'not saved' indicator here
 if (Panel.Index=0) and (HasChanged) then
  icons.Draw(StatusBar.Canvas,Rect.Left+2,Rect.Top+2,changedicon);
 //Second panel - needs a logo
 if (Panel.Index=1) and (Panel.Text<>'') then
 begin
  png:=0;
  case Image.FormatNumber shr 4 of
   0: png:=bbclogo;       //BBC Micro logo for DFS
   1:
   begin
    if(Image.FormatNumber mod $10<>3)
    and(Image.MapType=0) then png:=acornlogo; //Acorn logo for 8 bit ADFS
    if(Image.FormatNumber mod $10=3)
    or(Image.MapType=1) then png:=riscoslogo; //RISC OS logo for 32 bit ADFS
   end;
   2: png:=commodorelogo; //Commodore logo
   3: png:=sinclairlogo;  //Sinclair logo
   4: png:=amigalogo;     //Amiga logo
  end;
  if png<>0 then icons.Draw(StatusBar.Canvas,Rect.Left+2,Rect.Top+2,png);
  StatusBar.Canvas.Font:=StatusBar.Font;
  StatusBar.Canvas.TextRect(Rect,Rect.Left+20,Rect.Top+2,Panel.Text);
 end;
end;

{------------------------------------------------------------------------------}
//Validate a filename for Windows
{------------------------------------------------------------------------------}
procedure TMainForm.ValidateFilename(var f: AnsiString);
var
 i: Integer;
begin
 for i:=1 to Length(f) do
  if (f[i]='\')
  or (f[i]='/')
  or (f[i]=':')
  or (f[i]='*')
  or (f[i]='?')
  or (f[i]='"')
  or (f[i]='<')
  or (f[i]='>')
  or (f[i]='|') then
   f[i]:=' ';
end;

{------------------------------------------------------------------------------}
//Report an error to the user
{------------------------------------------------------------------------------}
procedure TMainForm.ReportError(error: AnsiString);
begin
 //If we are in command line mode, then do not use the GUI
 if ParamCount>0 then
  WriteLn(error)
 else //Otherwise, display a nice window on the screen
  ShowMessage(error);
end;

end.
