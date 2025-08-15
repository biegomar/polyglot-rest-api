unit Controller;

interface

uses
  System.JSON,
  System.SysUtils,
  System.Generics.Collections,
  Neon.Core.Types,
  Neon.Core.Attributes,
  Neon.Core.Persistence,
  Neon.Core.Persistence.JSON,
  Neon.Core.Utils,
  Horse,
  Model,
  Configuration;

type

  TUserController = class
  private
    FUsers: TDictionary<Integer, TUser>;
    FNextID: Integer;
    procedure InitSampleData;
    procedure LogRequest(const Method, Path, Status: string; const ExtraInfo: string = '');
  public
    constructor Create;
    destructor Destroy; override;

    class procedure MapRoutes;

    procedure GetAllUsers(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure GetUser(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure CreateUser(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure UpdateUser(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure DeleteUser(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  end;

  TInfoController = class
  private
    procedure LogRequest(const Method, Path, Status: string; const ExtraInfo: string = '');
  public
    class procedure MapRoutes;

    procedure GetInfo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure GetHealth(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  end;

var
  UserController: TUserController;
  InfoController: TInfoController;

implementation

{ TUserController }

constructor TUserController.Create;
begin
  FUsers := TDictionary<Integer, TUser>.Create;
  FNextID := 1;
  InitSampleData;
end;

procedure TUserController.CreateUser(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Body: TJSONObject;
  User: TUser;
  Name, Email: string;
  Age: Integer;
  JsonResponse: TJSONObject;
begin
  try
    Body := Req.Body<TJSONObject>;

    if not Body.TryGetValue<string>('name', Name) or (Name.Trim = '') then
    begin
      LogRequest('POST', '/api/users', '400 BAD REQUEST', 'Name missing');
      Res.Status(400).Send('{"error": "Name is required"}');
      Exit;
    end;

    if not Body.TryGetValue<string>('email', Email) or (Email.Trim = '') then
    begin
      LogRequest('POST', '/api/users', '400 BAD REQUEST', 'Email missing');
      Res.Status(400).Send('{"error": "Email is required"}');
      Exit;
    end;

    if not Body.TryGetValue<Integer>('age', Age) then
      Age := 0;

    // Neuen User erstellen
    User.ID := FNextID;
    User.Name := Name;
    User.Email := Email;

    FUsers.Add(FNextID, User);
    Inc(FNextID);

    // Response
    JsonResponse := TJSONObject.Create;
    JsonResponse.AddPair('id', TJSONNumber.Create(User.ID));
    JsonResponse.AddPair('name', User.Name);
    JsonResponse.AddPair('email', User.Email);
    JsonResponse.AddPair('message', 'User created successfully');

    LogRequest('POST', '/api/users', '201 CREATED', 'User: ' + User.Name + ' (ID: ' + User.ID.ToString + ')');
    Res.Status(201).Send<TJSONObject>(JsonResponse);
  except
    on E: Exception do
    begin
      LogRequest('POST', '/api/users', '400 BAD REQUEST', 'Invalid JSON: ' + E.Message);
      Res.Status(400).Send('{"error": "Invalid JSON data"}');
    end;
  end;

end;

procedure TUserController.DeleteUser(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  UserId: Integer;
  User: TUser;
begin
  try
    UserId := StrToInt(Req.Params['id']);
  except
    LogRequest('DELETE', '/api/users/' + Req.Params['id'], '400 BAD REQUEST', 'Invalid ID');
    Res.Status(400).Send('{"error": "Invalid user ID"}');
    Exit;
  end;

  if not FUsers.ContainsKey(UserId) then
  begin
    LogRequest('DELETE', '/api/users/' + UserId.ToString, '404 NOT FOUND', 'User not found');
    Res.Status(404).Send('{"error": "User not found"}');
    Exit;
  end;

  // User-Info f�r Log speichern bevor er gel�scht wird
  FUsers.TryGetValue(UserId, User);
  FUsers.Remove(UserId);

  LogRequest('DELETE', '/api/users/' + UserId.ToString, '204 NO CONTENT', 'Deleted: ' + User.Name);
  Res.Status(204).Send('');
end;

destructor TUserController.Destroy;
begin
  FUsers.Free;
  inherited;
end;

procedure TUserController.GetAllUsers(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var

  JsonUser: TJSONValue;
  User: TUser;
  UserList: TObjectList<TUser>;
begin
  UserList := TObjectList<TUser>.Create();

  for User in FUsers.Values do
  begin
    UserList.Add(User);
  end;

  JsonUser := TNeon.ObjectToJSON(UserList, NeonConfig);
  LogRequest('GET', '/api/users', '200 OK', Format('(%d users)', [FUsers.Count]));
  Res.Send<TJSONValue>(JsonUser);

end;

procedure TUserController.GetUser(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  JsonUser: TJSONValue;
  UserId: Integer;
  User: TUser;
begin
  try
    UserId := StrToInt(Req.Params['id']);
  except
    LogRequest('GET', '/api/users/' + Req.Params['id'], '400 BAD REQUEST', 'Invalid ID');
    Res.Status(400).Send('{"error": "Invalid user ID"}');
    Exit;
  end;

  if not FUsers.TryGetValue(UserId, User) then
  begin
    LogRequest('GET', '/api/users/' + UserId.ToString, '404 NOT FOUND', 'User not found');
    Res.Status(404).Send('{"error": "User not found"}');
    Exit;
  end;

  JsonUser := TNeon.ObjectToJSON(User, NeonConfig);

  LogRequest('GET', '/api/users/' + UserId.ToString, '200 OK', 'User: ' + User.Name);
  Res.Send<TJSONValue>(JsonUser);
end;

procedure TUserController.InitSampleData;
var
  User: TUser;
begin
  User := TUser.Create;
  User.ID := FNextID;
  User.Name := 'Max Mustermann';
  User.Email := 'max@example.com';
  FUsers.Add(FNextID, User);
  Inc(FNextID);

  User := TUser.Create;
  User.ID := FNextID;
  User.Name := 'Anna Schmidt';
  User.Email := 'anna@example.com';
  FUsers.Add(FNextID, User);
  Inc(FNextID);
end;

procedure TUserController.UpdateUser(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Body: TJSONObject;
  UserId: Integer;
  User: TUser;
  Name, Email: string;
  Age: Integer;
  JsonResponse: TJSONObject;
begin
  try
    UserId := StrToInt(Req.Params['id']);
  except
    LogRequest('PUT', '/api/users/' + Req.Params['id'], '400 BAD REQUEST', 'Invalid ID');
    Res.Status(400).Send('{"error": "Invalid user ID"}');
    Exit;
  end;

  if not FUsers.TryGetValue(UserId, User) then
  begin
    LogRequest('PUT', '/api/users/' + UserId.ToString, '404 NOT FOUND', 'User not found');
    Res.Status(404).Send('{"error": "User not found"}');
    Exit;
  end;

  try
    Body := Req.Body<TJSONObject>;

    // Daten aktualisieren
    if Body.TryGetValue<string>('name', Name) then
      User.Name := Name;
    if Body.TryGetValue<string>('email', Email) then
      User.Email := Email;

    // User im Dictionary aktualisieren
    FUsers[UserId] := User;

    // Response
    JsonResponse := TJSONObject.Create;
    JsonResponse.AddPair('id', TJSONNumber.Create(User.ID));
    JsonResponse.AddPair('name', User.Name);
    JsonResponse.AddPair('email', User.Email);
    JsonResponse.AddPair('message', 'User updated successfully');

    LogRequest('PUT', '/api/users/' + UserId.ToString, '200 OK', 'Updated: ' + User.Name);
    Res.Send<TJSONObject>(JsonResponse);
  except
    on E: Exception do
    begin
      LogRequest('PUT', '/api/users/' + UserId.ToString, '400 BAD REQUEST', 'Invalid JSON: ' + E.Message);
      Res.Status(400).Send('{"error": "Invalid JSON data"}');
    end;
  end;
end;

procedure TUserController.LogRequest(const Method, Path, Status, ExtraInfo: string);
begin
  Writeln(Format('[%s] %s %s - %s %s', [FormatDateTime('hh:nn:ss', Now), Method, Path, Status, ExtraInfo]));
end;

class procedure TUserController.MapRoutes;
begin
  THorse.Get('/api/users', UserController.GetAllUsers);
  THorse.Get('/api/users/:id', UserController.GetUser);
  THorse.Post('/api/users', UserController.CreateUser);
  THorse.Put('/api/users/:id', UserController.UpdateUser);
  THorse.Delete('/api/users/:id', UserController.DeleteUser);
end;

{ TInfoController }

procedure TInfoController.GetHealth(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Health: TJSONObject;
begin
  Health := TJSONObject.Create;
  Health.AddPair('healthy at', FormatDateTime('dd.mm.yyyy hh:nn:ss', Now));
  LogRequest('GET', '/api/health', '200 OK', 'Health requested');
  Res.Send<TJSONObject>(Health);
end;

procedure TInfoController.GetInfo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Info: TJSONObject;
begin
  Info := TJSONObject.Create;
  Info.AddPair('name', 'Simple User API');
  Info.AddPair('version', '1.0.0');
  Info.AddPair('storage', 'In-Memory Dictionary');
  LogRequest('GET', '/api/info', '200 OK', 'Info requested');
  Res.Send<TJSONObject>(Info);
end;

procedure TInfoController.LogRequest(const Method, Path, Status, ExtraInfo: string);
begin
  Writeln(Format('[%s] %s %s - %s %s', [FormatDateTime('hh:nn:ss', Now), Method, Path, Status, ExtraInfo]));
end;

class procedure TInfoController.MapRoutes;
begin
  THorse.Get('/api/info', InfoController.GetInfo);
  THorse.Get('/api/health', InfoController.GetHealth);
end;

initialization
  UserController := TUserController.Create;
  InfoController := TInfoController.Create;

end.
