class TagController < ApplicationController

  def updateTags
    @post = Post.find_by(id: edit_post_tags_params[:post_id])
    begin
      if @post.user_id == @current_user.id
        new_tags = edit_post_tags_params[:tags] || []
        @post.tags.clear # clear all tags
        new_tags.each do |tag_name|
          tag_name = tag_name.strip
          tag = Tag.find_or_create_by(name: tag_name)
          @post.tags << tag unless @post.tags.include?(tag)
        end
        @post.save
        render json: { message: "Post updated successfully with tags"}
        return
      else
        render json: { message: "Unauthorized action" }
        return
      end
    rescue
      render json: { message: "An error has occurred" }
    end
  end

  private

  def edit_post_tags_params
    params.require(:post).permit(:post_id, tags: [])
  end
end
