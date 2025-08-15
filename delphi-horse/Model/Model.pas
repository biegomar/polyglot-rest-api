unit Model;

interface

type
  TCreateUser = class
  private
    FName: string;
    FDescription: string;
    FEmail: string;
  public
    property Name: string read FName write FName;
    property Description: string read FDescription write FDescription;
    property Email: string read FEmail write FEmail;
  end;

  TUser = class
  private
    FID: Integer;
    FName: string;
    FDescription: string;
    FEmail: string;
  public
    property ID: Integer read FID write FID;
    property Name: string read FName write FName;
    property Description: string read FDescription write FDescription;
    property Email: string read FEmail write FEmail;
  end;

implementation

end.
