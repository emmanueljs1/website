--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll


--------------------------------------------------------------------------------

main :: IO ()
main = hakyll $ do
    match "files/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "fonts/*" $ do
        route idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    create["research.html"] $ do
        route idRoute
        compile $ do
            pubs <- recentFirst =<< loadAll "pubs/*"
            drafts <- recentFirst =<< loadAll "drafts/*"
            let baseContext = 
                      listField "drafts" shortDateCtx (return drafts) `mappend`
                      defaultContext
            let context =
                  if null pubs then
                      baseContext
                  else
                      listField "pubs" shortDateCtx (return pubs) `mappend`
                      baseContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/research.html" context
                >>= loadAndApplyTemplate "templates/default.html" context
                >>= relativizeUrls

    create["news.html"] $ do
        route idRoute
        compile $ do
            news <- recentFirst =<< loadAll "news/*"
            let newsContext =
                      listField "news" shortDateCtx (return news) `mappend`
                      defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/news.html" newsContext
                >>= loadAndApplyTemplate "templates/default.html" newsContext
                >>= relativizeUrls

    create ["posts.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let postsCtx =
                      listField "posts" postCtx (return posts) `mappend`
                      constField "title" "Posts" `mappend`
                      defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/posts.html" postsCtx
                >>= loadAndApplyTemplate "templates/default.html" postsCtx
                >>= relativizeUrls

    match "drafts/*" $ do
      compile pandocCompiler

    match "pubs/*" $ do
      compile pandocCompiler

    match "news/*" $ do
      compile pandocCompiler

    match "posts/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html" postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    match "cv.html" $ do
      route idRoute
      compile $ do
        getResourceBody
            >>= applyAsTemplate defaultContext
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    match "index.html" $ do
        route idRoute
        compile $ do
            allPosts <- recentFirst =<< loadAll "posts/*"
            allNews <- recentFirst =<< loadAll "news/*"
            let posts = take 3 allPosts
            let news = take 3 allNews
            let indexCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    listField "news" shortDateCtx (return news) `mappend`
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateBodyCompiler

--------------------------------------------------------------------------------
shortDateCtx :: Context String
shortDateCtx =
    dateField "date" "%B %Y" `mappend`
    defaultContext

postCtx :: Context String
postCtx =
    dateField "date" "%F" `mappend`
    defaultContext
