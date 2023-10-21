--
-- cStore:new()
--
-------------------------------------------------------------------------------

function cStore:new(aDirPath, aFileName)
  local object = {};

  object.fileDirPath = aDirPath;
  object.fileName = aFileName;
  object.filePath = aDirPath .."/".. aFileName;

  setmetatable(object, self);

  self.__index = self;

  return object;
end
-------------------------------------------------------------------------------

