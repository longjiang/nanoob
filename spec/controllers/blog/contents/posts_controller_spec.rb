require 'rails_helper'

RSpec.describe Blog::Contents::PostsController, type: :controller do
  
  let(:posts) { FactoryGirl.create_list(:post, 5) }
  let(:updated_title) { "a new title" }
  
  before(:each) do 
    sign_in user
  end
  
  context "A user without role" do

    let(:user) { FactoryGirl.create(:user) }
    let(:post) { FactoryGirl.create(:post, owner: user) }
    let(:post_attrs) {  attributes_with_foreign_keys(:post).merge("owner_id" => user.id)  }

    describe "#index" do
      before(:each) { get :index }
      it "redirects" do
        expect(response).to have_http_status(303)
      end
    end

    describe "#show" do
      before(:each) { get :show, params: { id: post.id } }
      it "redirects" do
        expect(response).to have_http_status(303)
      end
    end

    describe "#new" do
      before(:each) { get :new }
      it "redirects" do
        expect(response).to have_http_status(303)
      end
    end

    describe "#create" do
      before(:each) { process :create, method: :post, params: {blog_contents_post: post_attrs} }
      it "redirects" do
        expect(response).to have_http_status(303)
      end
    end

    describe "#edit" do
      before(:each) { get :edit, params: { id: post.id } }
      it "redirects" do
        expect(response).to have_http_status(303)
      end
    end

    describe "#upate" do
      before(:each) { patch :update, params: { id: post.id, blog_contents_post: post.attributes.merge("title" => updated_title) } }
      it "redirects" do
        expect(response).to have_http_status(303)
      end
    end

    describe "#destroy" do
      before(:each) { delete :destroy, params: { id: post.id } }
      it "redirects" do
        expect(response).to have_http_status(303)
      end
    end

  end # end no role

  %w(admin editor blogger).each do |role|

    context "A user with #{role} role" do
    
      let(:user) { FactoryGirl.create(role.to_sym) }
    
      post_attributes = attributes_with_foreign_keys(:post)

      describe "#index" do
        before(:each) { get :index }
        it "success" do
          expect(response).to be_success
        end
        it "assigns all posts to @posts" do
          expect(assigns(:posts)).to match_array posts
        end
      end

      describe "#show" do
        before(:each) { get :show, params: { id: FactoryGirl.create(:post).id } }
        it "success" do
          expect(response).to be_success
        end
      end

      describe "#new" do
        before(:each) { get :new }
        it "success" do
          expect(assigns(:post)).to be_a_new(Blog::Contents::Post)
        end
        it "should be assigned as owner" do
          expect(assigns(:post).owner_id).to eq(user.id)
        end
      end

      describe "#create" do
        posts_count = Blog::Contents::Post.count
        before(:each) { process :create, method: :post, params: {blog_contents_post: post_attrs} }
        context "when valid" do
          let(:post_attrs) {  attributes_with_foreign_keys(:post).merge("owner_id" => user.id)  }
          let(:last_post) { Blog::Contents::Post.reorder(:created_at).last }
          it "success" do
            expect(Blog::Contents::Post.count).to eq(posts_count + 1)
          end
          it "should assign user as owner" do
            expect(last_post.owner_id).to eql(user.id)
          end
          it 'should redirect to show page' do
            expect(response).to redirect_to(blog_contents_post_path(last_post))
          end
        end
        context "when not valid" do
          let(:post_attrs) {  attributes_with_foreign_keys(:post).merge("owner_id" => user.id, "title" => nil)  }
          it "stays on new Page" do
            expect(response).to render_template(:new)
          end
        end
      end

      %w(edit update).each do |action|
        describe "##{action}" do
          if action.eql?('edit')
            before(:each) { get :edit, params: { id: post.id } }
          else
            before(:each) { patch :update, params: { id: post.id, blog_contents_post: post.attributes.merge("title" => updated_title) } }
          end
          context "when owns post" do
            let(:post) { FactoryGirl.create(:post, owner: user) }
            it "success" do
              action.eql?('edit') ? expect(response).to(have_http_status(200)) : expect(post.reload.title).to(eql(updated_title))
            end
          end
          context "when doesnt own post" do
            let(:post) { FactoryGirl.create(:post) }
            if role.eql?('admin')
              it "success" do
                action.eql?('edit') ? expect(response).to(have_http_status(200)) : expect(post.reload.title).to(eql(updated_title))
              end
            else
              it "redirects" do
                expect(response).to have_http_status(303)
              end
            end
          end
          context "when is writer" do
            let(:post) { FactoryGirl.create(:post, writer: user, status: status) }
            context "when post is draft" do
              let(:status) { 'draft' }
              it "success" do
                action.eql?('edit') ? expect(response).to(have_http_status(200)) : expect(post.reload.title).to(eql(updated_title))
              end
            end
            %w(submitted published).each do |s|
              context "when post is #{s}" do
                let(:status) { s }
                if role.eql?('admin')
                  it "success" do
                    action.eql?('edit') ? expect(response).to(have_http_status(200)) : expect(post.reload.title).to(eql(updated_title))
                  end
                else
                  it "redirects" do
                    expect(response).to have_http_status(303)
                  end
                end
              end
            end
          end
          context "when is editor" do
            let(:post) { FactoryGirl.create(:post, editor: user, status: status) }
            context "when post is submitted" do
              let(:status) { 'submitted' }
              it "success" do
                action.eql?('edit') ? expect(response).to(have_http_status(200)) : expect(post.reload.title).to(eql(updated_title))
              end
            end
            %w(draft published).each do |s|
              context "when post is #{s}" do
                let(:status) { s }
                if role.eql?('admin')
                  it "success" do
                    action.eql?('edit') ? expect(response).to(have_http_status(200)) : expect(post.reload.title).to(eql(updated_title))
                  end
                else
                  it "redirects" do
                    expect(response).to have_http_status(303)
                  end
                end
              end
            end
          end
          context "when is optimizer" do
            let(:post) { FactoryGirl.create(:post, optimizer: user, status: status) }
            context "when post is draft" do
              let(:status) { 'draft' }
              if role.eql?('admin')
                it "success" do
                  action.eql?('edit') ? expect(response).to(have_http_status(200)) : expect(post.reload.title).to(eql(updated_title))
                end
              else
                it "redirects" do
                  expect(response).to have_http_status(303)
                end
              end
            end
            %w(submitted published).each do |s|
              context "when post is #{s}" do
                let(:status) { s }
                it "success" do
                  action.eql?('edit') ? expect(response).to(have_http_status(200)) : expect(post.reload.title).to(eql(updated_title))
                end
              end
            end
          end
        end

      end


      describe "#destroy" do
        posts_count = Blog::Contents::Post.count
        before(:each) { delete :destroy, params: { id: post.id } }
        context "when owns post" do
          let(:post) { FactoryGirl.create(:post, owner: user) }
          it "success" do
            expect(Blog::Contents::Post.count).to eq(posts_count)
          end
        end
        context "when doesnt own post" do
          let(:post) { FactoryGirl.create(:post) }
          if role.eql?('admin')
            it "success" do
              expect(Blog::Contents::Post.count).to eq(posts_count)
            end
          else
            it "redirects" do
              expect(response).to have_http_status(303)
            end
          end
        end
        context "when is writer" do
          let(:post) { FactoryGirl.create(:post, writer: user, status: status) }
          context "when post is draft" do
            let(:status) { 'draft' }
            it "success" do
              expect(Blog::Contents::Post.count).to eq(posts_count)
            end
          end
          %w(submitted published).each do |s|
            context "when post is #{s}" do
              let(:status) { s }
              if role.eql?('admin')
                it "success" do
                  expect(Blog::Contents::Post.count).to eq(posts_count)
                end
              else
                it "redirects" do
                  expect(response).to have_http_status(303)
                end
              end
            end
          end
        end
        context "when is editor" do
          let(:post) { FactoryGirl.create(:post, editor: user, status: status) }
          context "when post is submitted" do
            let(:status) { 'submitted' }
            it "success" do
              expect(Blog::Contents::Post.count).to eq(posts_count)
            end
          end
          %w(draft published).each do |s|
            context "when post is #{s}" do
              let(:status) { s }
              if role.eql?('admin')
                it "success" do
                  expect(Blog::Contents::Post.count).to eq(posts_count)
                end
              else
                it "redirects" do
                  expect(response).to have_http_status(303)
                end
              end
            end
          end
        end
        context "when is optimizer" do
          let(:post) { FactoryGirl.create(:post, optimizer: user, status: status) }
          %w(draft submitted published).each do |s|
            context "when post is #{s}" do
              let(:status) { s }
              if role.eql?('admin')
                it "success" do
                  expect(Blog::Contents::Post.count).to eq(posts_count)
                end
              else
                it "redirects" do
                  expect(response).to have_http_status(303)
                end
              end
            end
          end
        end
      end

      describe "#submit" do

        before(:each) { patch :update, params: {  submit_for_review: true, id: post.id, blog_contents_post: post.attributes.merge("title" => updated_title) } }

        %w(owner writer).each do |user_role|
          context "when is #{user_role}" do
            let(:post) { post_with_role user_role }
            context "when post is draft" do
              let(:status) { 'draft' }
              it "success" do
                expect(assigns(:post).status).to eq("submitted")
              end
            end
            %w(submitted published).each do |s|
              context "when post is #{s}" do
                let(:status) { s }
                it "redirects" do
                  expect(response).to have_http_status(303)
                end
              end
            end
          end
        end

        %w(editor optimizer nobody).each do |user_role|
          context "when is #{user_role}" do
            let(:post) { post_with_role user_role }
            context "when post is draft" do
              let(:status) { 'draft' }
              if role.eql?('admin')
                it "success" do
                  expect(assigns(:post).status).to eq("submitted")
                end
              else
                it "redirects" do
                  expect(response).to have_http_status(303)
                end
              end
            end
            %w(submitted published).each do |s|
              context "when post is #{s}" do
                let(:status) { s }
                it "redirects" do
                  expect(response).to have_http_status(303)
                end
              end
            end
          end
        end
      end

      describe "#refuse" do

        before(:each) { patch :update, params: {  refuse: true, id: post.id, blog_contents_post: post.attributes.merge("title" => updated_title) } }

        %w(owner editor).each do |user_role|
          context "when is #{user_role}" do
            let(:post) { post_with_role user_role }
            context "when post is submitted" do
              let(:status) { 'submitted' }
              it "success" do
                expect(assigns(:post).status).to eq("draft")
              end
            end
            %w(draft published).each do |s|
              context "when post is #{s}" do
                let(:status) { s }
                it "redirects" do
                  expect(response).to have_http_status(303)
                end
              end
            end
          end
        end

        %w(writer optimizer nobody).each do |user_role|
          context "when is #{user_role}" do
            let(:post) { post_with_role user_role }
            context "when post is submitted" do
              let(:status) { 'submitted' }
              if role.eql?('admin')
                it "success" do
                  expect(assigns(:post).status).to eq("draft")
                end
              else
                it "redirects" do
                  expect(response).to have_http_status(303)
                end
              end
            end
            %w(draft published).each do |s|
              context "when post is #{s}" do
                let(:status) { s }
                it "redirects" do
                  expect(response).to have_http_status(303)
                end
              end
            end
          end
        end
      end

      describe "#publish" do

        before(:each) { patch :update, params: {  publish: true, id: post.id, blog_contents_post: post.attributes.merge("title" => updated_title) } }

        context "when is owner" do
          let(:post) { post_with_role 'owner' }
          context "when post is published" do
            let(:status) { 'published' }
            it "redirects" do
              expect(response).to have_http_status(303)
            end
          end
          %w(draft submitted).each do |s|
            context "when post is le #{s}" do
              let(:status) { s }
              if role.eql?('admin') || role.eql?('editor')
                it "success" do
                  expect(assigns(:post).status).to eq("published")
                end
              else 
                it "redirects" do
                  expect(response).to have_http_status(303)
                end
              end
            end
          end
        end
        
        
        %w(optimizer nobody).each do |user_role|
          context "when is #{user_role}" do
            let(:post) { post_with_role user_role }
            context "when post is published" do
              let(:status) { 'published' }
              it "redirects" do
                expect(response).to have_http_status(303)
              end
            end
            %w(draft submitted).each do |s|
              context "when post is #{s}" do
                let(:status) { s }
                if role.eql?('admin')
                  it "success" do
                    expect(assigns(:post).status).to eq("published")
                  end
                else
                  it "redirects" do
                    expect(response).to have_http_status(303)
                  end
                end
              end
            end
          end
        end

        context "when is a writer" do
          let(:post) { post_with_role 'writer' }
          context "when post is draft" do
            let(:status) { 'draft' }
            if role.eql?('admin') || role.eql?('editor')
              it "success" do
                expect(assigns(:post).status).to eq("published")
              end
            else
              it "redirects" do
                expect(response).to have_http_status(303)
              end
            end
          end
          context "when post is submitted" do
            let(:status) { 'submitted' }
            if role.eql?('admin')
              it "success" do
                expect(assigns(:post).status).to eq("published")
              end
            else
              it "redirects" do
                expect(response).to have_http_status(303)
              end
            end
          end
          context "when post is published" do
            let(:status) { 'published' }
            it "redirects" do
              expect(response).to have_http_status(303)
            end
          end
        end

        context "when is editor" do
          let(:post) { post_with_role 'editor' }
          context "when post is draft" do
            let(:status) { 'draft' }
            if role.eql?('admin')
              it "success" do
                expect(assigns(:post).status).to eq("published")
              end
            else
              it "redirects" do
                expect(response).to have_http_status(303)
              end
            end
          end
          
          context "when post is submitted" do
            let(:status) { 'submitted' }
            if role.eql?('admin') || role.eql?('editor')
              it "success" do
                expect(assigns(:post).status).to eq("published")
              end
            else
              it "redirects" do
                expect(response).to have_http_status(303)
              end
            end
          end
          context "when post is published" do
            let(:status) { 'published' }
            it "redirects" do
              expect(response).to have_http_status(303)
            end
          end
        end
      end




      describe "#unpublish" do

        before(:each) { patch :update, params: {  unpublish: true, id: post.id, blog_contents_post: post.attributes.merge("title" => updated_title) } }
        

        %w(writer editor optimizer nobody).each do |user_role|
          context "when is #{user_role}" do
            let(:post) { post_with_role user_role }      
            context "when post is published" do
              let(:status) { 'published' }
              if role.eql?('admin')
                it "success" do
                  expect(assigns(:post).status).to eq("draft")
                end
              else
                it "redirects" do
                  expect(response).to have_http_status(303)
                end
              end
            end
            %w(draft submitted).each do |s|
              context "when post is #{s}" do
                let(:status) { s }
                it "redirects" do
                  expect(response).to have_http_status(303)
                end
              end
            end
          end
        end 
      
        user_role = 'owner'
        context "when is #{user_role}" do
          let(:post) { post_with_role user_role }
          context "when post is published" do
            let(:status) { 'published' }
            it "success" do
              expect(assigns(:post).status).to eq("draft")
            end
          end
          %w(draft submitted).each do |s|
            context "when post is #{s}" do
              let(:status) { s }
              it "redirects" do
                expect(response).to have_http_status(303)
              end
            end
          end
        end
      end
    end
    
  end

end
