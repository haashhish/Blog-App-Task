class PostController < ApplicationController
  before_action :authenticate

  def create
    @post = Post.new(new_post_params.except(:tags))
    if new_post_params[:tags].blank?
      render json: {message:"At least one tag should be provided"}
      return
    end
    @post.user_id = @current_user.id #link user with the post

    if @post.save
        new_tags = new_post_params[:tags]
        new_tags.each do |tag_name|
          tag = Tag.find_or_create_by(name: tag_name) #either assign to an existing tag, or create a new one
          @post.tags << tag unless @post.tags.include?(tag)
        end
        DeletePostJob.set(wait: 24.hours).perform_later(@post.id) # to perform deletion after 24 hours
      render json: { message: "Post created successfully", post: @post }
    else
      render json: { message: "Post not created!"}
    end
  end

  def updatePost
    @post = Post.find_by(id: edit_post_params[:post_id])
    begin
    if @post.user_id == @current_user.id
      @post.update(title: edit_post_params[:title], body: edit_post_params[:body])
      render json: {message: "Post updated successfully"}
    else
      render json: {message: "Cannot update post"}
    end
    rescue
      render json: { message: "An error occurred"}
    end
  end

  def deletePost
    @post = Post.find_by(id: edit_post_params[:post_id])
    if @post == nil
      render json: { message: "Post doesn't exist"}
    elsif @post.user_id != @current_user.id && @post != nil
      render json: { message: "Post doesn't belong to you"}
    else
      @post.destroy
      render json: { message: "Post deleted"}
    end
  end

  private

  def new_post_params
    params.require(:post).permit(:title, :body, tags: [])
  end

  def edit_post_params
    params.require(:post).permit(:post_id, :title, :body)
  end

  def delete_post_params
    params.require(:post).permit(:post_id)
  end
end
