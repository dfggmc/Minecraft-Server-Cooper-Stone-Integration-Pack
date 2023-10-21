--
-- cStore:updatePassword()
--
--------------------------------------------------------------------------------

function cStore:updatePassword(aPlayerName, aPlayerHash)

  local func_name = 'cStore:updatePassword()';
  local plLogin = aPlayerName:lower();
  local plHash = aPlayerHash;
  local count = 0;

  local sql =[=[
    UPDATE logins
    SET password = :plHash
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
    plLogin = plLogin,
    plHash = plHash
  });

  local ret = stmt:step();

  if ret ~= sqlite3.OK and ret ~= sqlite3.DONE then
    console_log(func_name .." -> ret code = ".. ret, 2);
    stmt:finalize();
    db:close();
    return false;
  end

  -- Clean handler
  stmt:finalize();

  -- Close DB
  db:close();

  return true;
end
--------------------------------------------------------------------------------

