class PostsController < ApplicationController
    before_action :find_post, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user!, only: [:new, :edit, :destroy]
    before_action :is_owner, only: [:edit, :destroy]
    
    def index
        @posts = Post.all.order("created_at DESC")
    end

    def show

    end

    def new
        @post = Post.new
    end

    def create
        @post = current_user.posts.build(post_params)
        if @post.save 
            redirect_to @post, notice: "Votre astuce a bien été créée !"
        else
            render "new"
        end
    end

    def edit

    end

    def update
        if @post.update(post_params)
            redirect_to @post, notice: "Votre astuce a bien été modifiée !"
        else
            render "edit"
        end
    end

    def destroy
        @post.destroy
        flash[:notice] = "Votre astuce a été supprimée"
        redirect_to root_path
    end

    private 

    def post_params
        params.require(:post).permit(:title, :body, :user)
    end

    def find_post
        @post = Post.find(params[:id])
    end

    def is_owner
        unless current_user == @post.user
        flash[:alert] = "Cette astuce ne vous appartient pas"
        redirect_to @post
        end
    end
end