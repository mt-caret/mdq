module Main where

import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import qualified Text.Pandoc as P
import Text.Pandoc.Walk (query)

extractURL :: P.Inline -> [T.Text]
extractURL (P.Link _ _ (href, _)) = [href]
extractURL (P.Image _ _ (href, _)) = [href]
extractURL _ = []

extractURLs :: P.Pandoc -> [T.Text]
extractURLs = query extractURL

readDoc :: P.PandocMonad m => T.Text -> m P.Pandoc
readDoc = P.readMarkdown P.def

main :: IO ()
main = do
  text <- TIO.getContents
  doc <- P.runIOorExplode $ readDoc text
  let urls = extractURLs doc
  TIO.putStr $ T.unlines urls
