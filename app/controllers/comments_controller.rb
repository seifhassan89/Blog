class CommentsController < ApplicationController
    before_action :find_post, only: [:index, :create]
    before_action :find_comment, only: [:show, :update, :destroy]
    before_action :check_role_from_header, only: [:update, :destroy]

    # GET /posts/:post_id/comments
    def index
        @comments = @post.comments.map do |comment|
            {
                id: comment.id,
                body: comment.body,
                commented_by: comment.user.name,
                commenter_id: comment.user.id,
                created_at: comment.created_at
            }
        end
        sendResponse @comments, true , :ok
    end

    # GET /posts/:post_id/comments/:id
    def show
        sendResponse @mappedComment, true , :ok
    end

    # POST /posts/:post_id/comments
    def create
        @comment = @post.comments.build(comment_params)
        if @comment.save
            sendResponse @comment, true , :created
        else
            sendResponse  @comment.errors, false , :unprocessable_entity
        end
    end

    # PATCH/PUT /posts/:post_id/comments/:id
    def update
        if @comment.update(comment_params)
            sendResponse  @comment, true , :ok
        else
            sendResponse  @comment.errors, false , :unprocessable_entity
        end
    end

    # DELETE /posts/:post_id/comments/:id
    def destroy
        @comment.destroy
        sendResponse @comment, true , :ok
    end

    private
    def find_comment
       @comment = Comment.includes(:user).find(params[:id])
       @mappedComment = {                        
            id: @comment.id,
            body: @comment.body,
            commented_by: @comment.user.name,
            commenter_id: @comment.user.id,
            created_at: @comment.created_at
        }
        return @mappedComment

        rescue ActiveRecord::RecordNotFound
            sendResponse  "Comment not found", false , :not_found
        return
        rescue ArgumentError
            sendResponse  "Invalid comment ID", false , :unprocessable_entity
        return
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:body, :user_id)
    end

    def check_role_from_header 
        authorization_header = request.headers["Authorization"]
        if authorization_header
            token = authorization_header.split(' ').last
            decoded_token = JWT.decode(token, Rails.application.config.jwt_secret_key, true, algorithm: 'HS256')
            role_id = decoded_token.first['role_id']
            user_id = decoded_token.first['user_id']
            if role_id.to_i == 1 || user_id == @comment.user.id
                return true
            else
                sendResponse  "You are not authorized to perform this action", false , :unauthorized
            end
        else
            sendResponse  "Please send Authorization in header", false , :unauthorized
        end
    end
end
