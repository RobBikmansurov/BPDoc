require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe BProcsController do

  # This should return the minimal set of attributes required to create a valid
  # BProc. As you add validations to BProc, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  describe "GET index" do
    it "assigns all b_procs as @b_procs" do
      b_proc = BProc.create! valid_attributes
      get :index
      assigns(:b_procs).should eq([b_proc])
    end
  end

  describe "GET show" do
    it "assigns the requested b_proc as @b_proc" do
      b_proc = BProc.create! valid_attributes
      get :show, :id => b_proc.id.to_s
      assigns(:b_proc).should eq(b_proc)
    end
  end

  describe "GET new" do
    it "assigns a new b_proc as @b_proc" do
      get :new
      assigns(:b_proc).should be_a_new(BProc)
    end
  end

  describe "GET edit" do
    it "assigns the requested b_proc as @b_proc" do
      b_proc = BProc.create! valid_attributes
      get :edit, :id => b_proc.id.to_s
      assigns(:b_proc).should eq(b_proc)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new BProc" do
        expect {
          post :create, :b_proc => valid_attributes
        }.to change(BProc, :count).by(1)
      end

      it "assigns a newly created b_proc as @b_proc" do
        post :create, :b_proc => valid_attributes
        assigns(:b_proc).should be_a(BProc)
        assigns(:b_proc).should be_persisted
      end

      it "redirects to the created b_proc" do
        post :create, :b_proc => valid_attributes
        response.should redirect_to(BProc.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved b_proc as @b_proc" do
        # Trigger the behavior that occurs when invalid params are submitted
        BProc.any_instance.stub(:save).and_return(false)
        post :create, :b_proc => {}
        assigns(:b_proc).should be_a_new(BProc)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        BProc.any_instance.stub(:save).and_return(false)
        post :create, :b_proc => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested b_proc" do
        b_proc = BProc.create! valid_attributes
        # Assuming there are no other b_procs in the database, this
        # specifies that the BProc created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        BProc.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => b_proc.id, :b_proc => {'these' => 'params'}
      end

      it "assigns the requested b_proc as @b_proc" do
        b_proc = BProc.create! valid_attributes
        put :update, :id => b_proc.id, :b_proc => valid_attributes
        assigns(:b_proc).should eq(b_proc)
      end

      it "redirects to the b_proc" do
        b_proc = BProc.create! valid_attributes
        put :update, :id => b_proc.id, :b_proc => valid_attributes
        response.should redirect_to(b_proc)
      end
    end

    describe "with invalid params" do
      it "assigns the b_proc as @b_proc" do
        b_proc = BProc.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        BProc.any_instance.stub(:save).and_return(false)
        put :update, :id => b_proc.id.to_s, :b_proc => {}
        assigns(:b_proc).should eq(b_proc)
      end

      it "re-renders the 'edit' template" do
        b_proc = BProc.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        BProc.any_instance.stub(:save).and_return(false)
        put :update, :id => b_proc.id.to_s, :b_proc => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested b_proc" do
      b_proc = BProc.create! valid_attributes
      expect {
        delete :destroy, :id => b_proc.id.to_s
      }.to change(BProc, :count).by(-1)
    end

    it "redirects to the b_procs list" do
      b_proc = BProc.create! valid_attributes
      delete :destroy, :id => b_proc.id.to_s
      response.should redirect_to(b_procs_url)
    end
  end

end