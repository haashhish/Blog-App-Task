class DeletePostJob < ApplicationJob
  queue_as :default

  def perform(*args)
    post = Post.find_by(id: post_id)
    post.destroy if post
  end
end
