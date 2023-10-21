--
-- cStore:existsPlayer()
--
--------------------------------------------------------------------------------

function cStore:existsPlayer(aPlayerName)

  local func_name = 'cStore:existsPlayer()';
  local status = false;
  local plLogin = aPlayerName:lower();
  local plHash = aPlayerHash;
  local count = 0;

  local sql =[=[
    SELECT COUNT(*)
    FROM logins
    WHERE login = :plLogin
    ;
  ]=];

  local db = sqlite3.open(self.filePath);

  if not db then
    console_log(func_name .."-> Can not open DB ".. self.filePath, 2);
    return false;
  end

  -- Execute statement
  local stmt = db:prepare(sql);

  -- Is it allright?
  if not stmt then
    console_log(func_name .." -> db:prepare is nil", 2);
    db:close();
    return false;
  end

  -- Bind names
  stmt:bind_names({
    plLogin = plLogin
  });

  -- get value
  for count1 in stmt:urows() do
    count = count1;
  end

  -- Clean handler
  stmt:finalize();

  -- Close DB
  db:close();

  -- Item not banned
  if count == 0 then
    return false;
  end

  return true;
end
--------------------------------------------------------------------------------

