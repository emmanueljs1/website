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
            let posts = take 3 allPosts
            let indexCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateBodyCompiler

--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%F" `mappend`
    defaultContext
