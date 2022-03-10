module SiteHelper
  def msg_jumbotron
    case params[:action]
    when 'index'
      "Ultimas perguntas cadastradas.."
    when 'questions'
      "Resultados para o termo \"#{params[:term]}\"..."
    when 'subject'
      "Mostrando por categoria \"#{params[:subject]}\"..."
    end
  end
end
