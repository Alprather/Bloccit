module UsersHelper
  def has_posts?
    @user.posts.any?
  end
  def has_comments?
    @user.comments.any?
  end
end
