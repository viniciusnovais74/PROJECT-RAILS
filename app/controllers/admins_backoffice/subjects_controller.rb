class AdminsBackoffice::SubjectsController < AdminsBackofficeController
  before_action :set_subjects, only: [:edit, :update, :destroy]

  def index
   @subjects = Subject.all.order(:description).page(params[:page]).per(25)
  end

  def new
    @subject = Subject.new
  end

  def create
    @subject = Subject.new(params_subject)
    if @subject.save()
      redirect_to admins_backoffice_subjects_path, notice: 'Assunto/area Cadastrado com Sucesso'
    else
      render :new
    end
  end

  def edit

  end

  def update
    if @subject.update(params_subject)
      redirect_to admins_backoffice_subjects_path, notice: 'Assunto/Areaa Atualizado com Sucesso'
    else
      render :edit
    end
  end


  def destroy
    if @subject.destroy()
      redirect_to admins_backoffice_subjects_path, notice: 'Assunto/Área Destruido com Sucesso'
    else
      render :index
    end
  end


  private
  
  def params_subject
    params.require(:subject).permit(:description)
  end

  def set_subjects
    @subject = Subject.find(params[:id])
  end

  
end
