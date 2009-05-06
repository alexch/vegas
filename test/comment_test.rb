require File.expand_path("#{File.dirname(__FILE__)}/test_setup")

class CommentTest < MyTestCase
  def test_add_comment_to_article
    doctor = User.create(:name => "frankenstein")
    igor = User.create(:name => "igor")
    article = Article.create(:name => "i just created life!", :author => doctor)
    comment = article.add_comment(igor, "need more brains")
    comment.reload
    article.reload
    assert_equal [comment], article.comments
  end
end
