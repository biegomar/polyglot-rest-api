program UserManagement;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  System.JSON,
  Controller in 'Controller\Controller.pas',
  Model in 'Model\Model.pas',
  Horse,
  Horse.Jhonson,
  Horse.CORS;

begin
  try
    UserController := TUserController.Create;
    InfoController := TInfoController.Create;

    // Middleware
    THorse.Use(Jhonson()).Use(CORS);

    // Routes
    THorse.Get('/api/users', UserController.GetAllUsers);
    THorse.Get('/api/users/:id', UserController.GetUser);
    THorse.Post('/api/users', UserController.CreateUser);
    THorse.Put('/api/users/:id', UserController.UpdateUser);
    THorse.Delete('/api/users/:id', UserController.DeleteUser);

    // Info Route
    THorse.Get('/api/info', InfoController.GetInfo);
    THorse.Get('/api/health', InfoController.GetHealth);

    Writeln('Simple User API starting...');
    Writeln('Available endpoints:');
    Writeln('  GET    /api/info');
    Writeln('  GET    /api/health');
    Writeln('');
    Writeln('  GET    /api/users');
    Writeln('  GET    /api/users/:id');
    Writeln('  POST   /api/users');
    Writeln('  PUT    /api/users/:id');
    Writeln('  DELETE /api/users/:id');
    Writeln('');
    Writeln('Press ENTER to stop the server...');
    Writeln('Logging all requests...');
    Writeln('');

    THorse.Listen(9000);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
