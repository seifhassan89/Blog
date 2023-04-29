class PostsController < ApplicationController
    before_action :find_post, only: [:show, :update, :destroy]
    before_action :check_role_from_header, only: [:update, :destroy]
    before_action :post_params_formData, only: [:create, :update]

    # GET /posts
    def index
        @posts = Post.includes(:user,:comments).all
        mappedPost = @posts.map do |post|
            {
                id: post.id,
                title:post.title,
                content:post.content,
                author_id: post.user.id,
                author_name: post.user.name,
                created_at: post.created_at,
                comments_count: post.comments.count,
            }
        end
        sendResponse mappedPost , true , :ok
    end

    # GET /posts/1
    def show
        sendResponse @mappedPost, true , :ok
    end

    # POST /posts
    def create
        post = Post.new(post_params_formData)
        if post.save
        sendResponse post, true , :created
        else
        sendResponse  post.errors, false , :unprocessable_entity
        end
    end

    # PATCH/PUT /posts/1
    def update
        if @post.update(post_params_formData)
            sendResponse @post, true , :ok
        else
            sendResponse  @post.errors, false , :unprocessable_entity
        end
    end

    # DELETE /posts/1
    def destroy
        @post.destroy
        sendResponse @post, true , :ok
    end

    private
        def find_post
            begin
                @post = Post.includes(:user,:comments).find(params[:id])
                @mappedPost = {
                    id: @post.id,
                    title:@post.title,
                    content:@post.content,
                    author_id: @post.user.id,
                    author_name: @post.user.name,
                    created_at: @post.created_at,
                    image_url: (@post.image.attached? ? url_for(@post.image) : nil),
                    comments: @post.comments.map do |comment|
                        {
                            id: comment.id,
                            body: comment.body,
                            commented_by: comment.user.name,
                            commenter_id: comment.user.id,
                            created_at: comment.created_at
                        }
                    end
                }
                return @mappedPost
                rescue ActiveRecord::RecordNotFound
                    sendResponse  "Post not found", false , :not_found
                return
                rescue ArgumentError
                    sendResponse  "Invalid post ID", false , :unprocessable_entity
                return                
            end
        end

        def post_params_formData
            params_hash = {}
            params_hash["title"] = params[:title]
            params_hash["content"] = params[:content]
            params_hash["user_id"] = params[:user_id].to_i
            params_hash["image"] = params[:image]
            return params_hash
        end

        # to override the inherited method from ApplicationController 
        def sendResponse payload, isSuccessful, status
            if isSuccessful
                render json: {data: payload, successful: true},include: :comments, status: status
            else
                render json: {message: payload, successful: false},include: :comments, status: status
            end
        end

        def check_role_from_header 
           authorization_header = request.headers["Authorization"]
            if authorization_header
                token = authorization_header.split(' ').last
                decoded_token = JWT.decode(token, Rails.application.config.jwt_secret_key, true, algorithm: 'HS256')
                role_id = decoded_token.first['role_id']
                user_id = decoded_token.first['user_id']
                if role_id.to_i == 1 || user_id == @post.user.id
                    return true
                else
                    sendResponse  "You are not authorized to perform this action", false , :unauthorized
                end
            else
                sendResponse  "Please send Authorization in header", false , :unauthorized
            end
        end
end
