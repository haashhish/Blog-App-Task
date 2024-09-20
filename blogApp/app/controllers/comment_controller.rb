class CommentController < ApplicationController
  
  def addComment
    @post = Post.find_by(id: newComment_params[:post_id])
    if @post == nil
      render json:{message:"Post doesn't exist"}
      return
    else
      @comment = Comment.new(newComment_params)
      @comment.user_id = @current_user.id
      @comment.save
      render json:{message:"Comment created successfully"}
    end
  end

  def editComment
    @comment = Comment.find_by(id: editComment_params[:id])
    if @comment == nil
      render json: { message: "Comment doesn't exist"}
    elsif @comment.user_id != @current_user.id && @comment != nil
      render json: { message: "Comment doesn't belong to you"}
    else
      @comment.update(body: editComment_params[:body])
      render json: { message: "Comment updated"}
    end
  end

  def deleteComment
    @comment = Comment.find_by(id: deleteComment_params[:id])
    if @comment == nil
      render json: { message: "Comment doesn't exist"}
    elsif @comment.user_id != @current_user.id && @comment != nil
      render json: { message: "Comment doesn't belong to you"}
    else
      @comment.destroy
      render json: { message: "Comment deleted"}
    end
  end

  private

  def newComment_params
    params.require(:comment).permit(:post_id, :body)
  end

  def editComment_params
    params.require(:comment).permit(:id, :body)
  end

  def deleteComment_params
    params.require(:comment).permit(:id)
  end
end
