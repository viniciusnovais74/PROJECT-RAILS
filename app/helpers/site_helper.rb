module SiteHelper
  def msg_jumbotron
    case params[:action]
    when 'index'
      "Ultimas perguntas cadastradas.."
    when 'questions'
      "Resultados para o termo \"#{sanitize params[:term]}\"..."
    when 'subject'
      "Mostrando por categoria \"#{sanitize params[:subject]}\"..."
    end
  end
end
