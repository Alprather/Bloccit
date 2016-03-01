class CommentsController < ApplicationController
  before_action :require_sign_in
  before_action :authorize_user, only: [:destroy]
  before_action :set_commentable

  def create
    comment = Comment.new(comment_params)
    comment.user = current_user

    if comment.save
      @commentable.comments << comment
      flash[:notice] = 'Comment saved successfully.'
    else
      flash[:alert] = 'Comment failed to save.'
    end
    
    redirect_to @redirect_url
  end

  def destroy
    comment = @commentable.comments.find(params[:id])

    if comment.destroy
      flash[:notice] = 'Comment was deleted.'
    else
      flash[:alert] = "Comment couldn't be deleted. Try again."
    end

    redirect_to @redirect_url
 end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def authorize_user
    comment = Comment.find(params[:id])
    unless current_user == comment.user || current_user.admin?
      flash[:alert] = 'You do not have permission to delete a comment.'
      redirect_to [comment.post.topic, comment.post]
    end
  end

  def set_commentable
    if params[:post_id]
      @commentable = Post.find(params[:post_id])
      @redirect_url = [@commentable.topic, @commentable]
    else
      @commentable = Topic.find(params[:topic_id])
      @redirect_url = [@commentable]
    end
  end
end
