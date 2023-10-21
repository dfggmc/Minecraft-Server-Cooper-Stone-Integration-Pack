--
-- getHash()
--
-------------------------------------------------------------------------------

function getHash(aStr)
-- Return hsh string for text string
-- easy, but medium security

  return cCryptoHash.sha1HexString(cCryptoHash.md5HexString(aStr));
end
-------------------------------------------------------------------------------

