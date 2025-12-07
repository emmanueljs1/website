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

    match "slides/*" $ do
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

    create["talks.html"] $ do
      route idRoute
      compile $ do
      talks <- recentFirst =<< loadAll "talks/*"
      let context =
                listField "talks" defaultContext (return talks) `mappend`
                defaultContext
      makeItem ""
          >>= loadAndApplyTemplate "templates/talks.html" context
          >>= loadAndApplyTemplate "templates/default.html" context
          >>= relativizeUrls

    create["projects.html"] $ do
        route idRoute
        compile $ do
            makeItem ""
                >>= loadAndApplyTemplate "templates/projects.html" defaultContext
                >>= loadAndApplyTemplate "templates/default.html" defaultContext
                >>= relativizeUrls

    create["research.html"] $ do
        route idRoute
        compile $ do
            pubs <- recentFirst =<< loadAll "pubs/*"
            drafts <- recentFirst =<< loadAll "drafts/*"
            let context = 
                      listField "drafts" shortDateCtx (return drafts) `mappend`
                      listField "pubs" shortDateCtx (return pubs) `mappend`
                      defaultContext

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

    match "pubs/*" $ do
      compile pandocCompiler

    match "talks/*" $ do
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
            allPubs <- recentFirst =<< loadAll "pubs/*"
            allPosts <- recentFirst =<< loadAll "posts/*"
            allNews <- recentFirst =<< loadAll "news/*"
            allTalks <- recentFirst =<< loadAll "talks/*"
            let pubs = take 5 allPubs
            let posts = take 3 allPosts
            let news = take 3 allNews
            let talks = take 3 allTalks
            let indexCtx =
                    listField "pubs" defaultContext (return pubs) `mappend`
                    listField "talks" defaultContext (return talks) `mappend`
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
