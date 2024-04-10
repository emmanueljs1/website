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

    match "drafts.html" $ compile getResourceBody

    match "research.html" $ do
      route idRoute
      compile $ do
        drafts <- loadBody "drafts.html"
        let researchCtx =
              constField "drafts" drafts `mappend`
              defaultContext
        getResourceBody
            >>= applyAsTemplate researchCtx
            >>= loadAndApplyTemplate "templates/default.html" researchCtx
            >>= relativizeUrls

    create["news.html"] $ do
        route idRoute
        compile $ do
            news <- recentFirst =<< loadAll "news/*"
            let newsContext =
                      listField "news" newsCtx (return news) `mappend`
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

    match "news/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/news-article.html" newsCtx
            >>= loadAndApplyTemplate "templates/default.html" newsCtx
            >>= relativizeUrls

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
                    listField "news" newsCtx (return news) `mappend`
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateBodyCompiler

--------------------------------------------------------------------------------
newsCtx :: Context String
newsCtx =
    dateField "date" "%B %Y" `mappend`
    defaultContext

postCtx :: Context String
postCtx =
    dateField "date" "%F" `mappend`
    defaultContext
