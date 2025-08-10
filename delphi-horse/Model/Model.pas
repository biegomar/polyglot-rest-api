unit Model;

interface

type
  TCreateUser = Record
    Name: String;
    Description: String;
    Email: String;
  end;

  TUser = Record
    ID: Integer;
    Name: String;
    Description: String;
    Email: String;
  end;

implementation

end.
