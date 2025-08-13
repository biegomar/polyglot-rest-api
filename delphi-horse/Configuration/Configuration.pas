unit Configuration;

interface

uses
  System.TypInfo,
  Neon.Core.Types,
  Neon.Core.Attributes,
  Neon.Core.Persistence,
  Neon.Core.Persistence.JSON,
  Neon.Core.Utils;

  function InitializeNeon : INeonConfiguration;

var
  NeonConfig: INeonConfiguration;

implementation

  function InitializeNeon : INeonConfiguration;
  begin
    Result := TNeonConfiguration.Default
    .SetMemberCase(TNeonCase.CamelCase)
    .SetMembers([TNeonMembers.Standard, TNeonMembers.Fields, TNeonMembers.Properties])
    .SetIgnoreFieldPrefix(True)
    .SetPrettyPrint(true)
    .SetVisibility([mvPublic, mvPublished]);
  end;

initialization
  NeonConfig := InitializeNeon;
end.
