unit HorseExtension;

interface

uses
  Horse;

type

  THorseHelper = class helper for THorse
    class procedure Welcome;
  end;

implementation

{ THorseHelper }

class procedure THorseHelper.Welcome;
begin
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
end;

end.
