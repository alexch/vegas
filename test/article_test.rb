require File.expand_path("#{File.dirname(__FILE__)}/test_setup")

class ArticleTest < MyTestCase

  def test_create
    article = Article.create(:name => "foo", :body => "bar")
    article.reload
    assert_equal "foo", article.name
    assert_equal "bar", article.body
  end

end
