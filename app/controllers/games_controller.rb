class GamesController < ApplicationController
  require 'net/http'
  require 'json'

  def new
    # je génére un array de 10 lettres au hasard pris dans cet array d'alphabet
    alphabet = ("A".."Z").to_a
    @letters = []
    # for n in 0..9
    #   monTableau << alphabet[rand(1..26)]
    # end

    while @letters.length < 10 # Tant que monTableau est inférieur ou égal à 10
      @letters << alphabet[rand(0..25)]
    end

    # raise
  end

  def score
    letters = params[:letters].split(',')
    user_word = params[:word]

    # 1-Le mot ne peut pas être créé à partir de la grille d’origine.
    # Exemple de validation : vérifier si le mot utilise uniquement les lettres fournies
    if valid_word?(user_word, letters)
      # Traitement pour un mot valide
      @message = "Bravo ! Le mot est valide."
      if word_exists?(user_word)
        # 3-Le mot est valide d’après la grille et est un mot anglais valide.
        @message = "Le mot '#{user_word}' existe."
      else
        # 2-Le mot est valide d’après la grille, mais ce n’est pas un mot anglais valide.
        @message = "Le mot '#{user_word}' n'existe pas."
      end
    else
      # Traitement pour un mot invalide
      @message = "Désolé, le mot n'est pas valide."
    end
    # raise
  end
end

def valid_word?(word, letters)
  word.chars.all? { |char| letters.include?(char.upcase) }
end

def word_exists?(word)
  url = URI("https://dictionary.lewagon.com/#{word}")
  response = Net::HTTP.get_response(url)
  # raise
  if response.code == '200'
    true
  else
    false
  end
end