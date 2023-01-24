/*


Este script tem como entrada uma string contendo o número do CNPJ
e retorna um valor booleano indicando se é válido ou não. Ele verifica se o CNPJ tem 14 dígitos,
se todos os dígitos são iguais, calcula os dígitos verificadores e compara-os com os dígitos do CNPJ passado como parâmetro.

Observe que esta é uma implementação simplificada, 
e é recomendado usar biblioteca já testadas e validadas para essa finalidade.

*/



Function U_EFValidCNPJ(cCNPJ)
  Local aCNPJ := Alltrim(cCNPJ)
  Local aValido := .F.
  Local aSoma, aResto, aDigito1, aDigito2, aContador

  // Verifica se o CNPJ tem 14 dígitos
  If Len(aCNPJ) <> 14
    Return aValido
  End

  // Verifica se todos os dígitos são iguais
  aContador := 0
  For aContador := 1 To 14
    If Substr(aCNPJ, aContador, 1) <> Substr(aCNPJ, 1, 1)
      Exit
    End
  Next

  // Calcula o primeiro dígito verificador
  aSoma := 0
  For aContador := 1 To 12
    aSoma += Val(Substr(aCNPJ, aContador, 1)) * (6 - (aContador - 8) mod 6)
  Next
  aResto := aSoma mod 11
  aDigito1 := 11 - aResto

  // Calcula o segundo dígito verificador
  aSoma := 0
  For aContador := 1 To 13
    aSoma += Val(Substr(aCNPJ, aContador, 1)) * (7 - (aContador - 8) mod 6)
  Next
  aResto := aSoma mod 11
  aDigito2 := 11 - aResto

  // Verifica se o CNPJ é válido
  If Val(Substr(aCNPJ, 13, 1)) = aDigito1 And Val(Substr(aCNPJ, 14, 1)) = aDigito2
    aValido := .T.
  End

  Return aValido
End
