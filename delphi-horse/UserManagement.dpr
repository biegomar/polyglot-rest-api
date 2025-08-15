program UserManagement;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  System.JSON,
  Controller,
  Model,
  Horse,
  Horse.Jhonson,
  Horse.CORS,
  Configuration,
  HorseExtension;

begin
  try
    TUserController.MapRoutes;
    TInfoController.MapRoutes;

    // Middleware
    THorse.Use(Jhonson()).Use(CORS);

    THorse.Welcome;

    THorse.Listen(9000);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
