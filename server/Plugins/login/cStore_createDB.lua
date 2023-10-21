--
-- cStore:createDB()
--
--------------------------------------------------------------------------------

function cStore:createDB()

  local func_name = 'cStore:createDB()';

  local sql =[=[
    CREATE TABLE IF NOT EXISTS "logins"(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      login TEXT,
      password TEXT,
      activated INTEGER DEFAULT 0
    );

    CREATE INDEX IF NOT EXISTS logins_login ON logins(login);
    CREATE INDEX IF NOT EXISTS logins_password ON logins(password);
    CREATE INDEX IF NOT EXISTS logins_activated ON logins(activated);
    CREATE INDEX IF NOT EXISTS logins_login_activated ON logins(login, activated);
    CREATE INDEX IF NOT EXISTS logins_login_password ON logins(login, password);
  ]=];

  local db = sqlite3.open(self.filePath);

  if not db then
    console_log(func_name .."-> Can not open DB ".. self.filePath, 2);
    return false;
  end

  -- Create tables
  if db:exec(sql) ~= sqlite3.OK then
    return false
  end

  -- Close DB
  db:close();

  return true;
end
--------------------------------------------------------------------------------

