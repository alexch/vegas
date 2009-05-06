class ArticleList < Erector::Widget  
  needs :articles
  def content
    ul :class => "article_list" do
      articles.each do |article|
        li do
          a article.name, :href => article.url
        end
      end
    end
  end
end
