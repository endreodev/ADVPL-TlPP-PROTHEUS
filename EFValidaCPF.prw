/*

Este script tem como entrada uma string contendo o número do CPF e retorna um valor booleano indicando se é válido ou não. 
Ele verifica se o CPF tem 11 dígitos, se todos os dígitos são iguais, calcula os dígitos verificadores e compara-os com os dígitos do CPF passado como parâmetro.

Observe que esta é uma implementação simplificada, e é recomendado usar biblioteca já testadas e validadas para essa finalidade.


*/

Function U_EFValidaCPF(cCPF)

  Local aCPF := Alltrim(cCPF)
  Local aValido := .F.
  Local aSoma, aResto, aDigito1, aDigito2, aContador

  // Verifica se o CPF tem 11 dígitos
  If Len(aCPF) <> 11
    Return aValido
  End

  // Verifica se todos os dígitos são iguais
  aContador := 0
  For aContador := 1 To 11
    If Substr(aCPF, aContador, 1) <> Substr(aCPF, 1, 1)
      Exit
    End
  Next

  // Calcula o primeiro dígito verificador
  aSoma := 0
  For aContador := 1 To 9
    aSoma += Val(Substr(aCPF, aContador, 1)) * (11 - aContador)
  Next
  aResto := (aSoma * 10) % 11
  If aResto = 10
    aDigito1 := 0
  Else
    aDigito1 := aResto
  End

  // Calcula o segundo dígito verificador
  aSoma := 0
  For aContador := 1 To 10
    aSoma += Val(Substr(aCPF, aContador, 1)) * (12 - aContador)
  Next
  aResto := (aSoma * 10) % 11
  If aResto = 10
    aDigito2 := 0
  Else
    aDigito2 := aResto
  End

  // Verifica se o CPF é válido
  If Val(Substr(aCPF, 10, 1)) = aDigito1 And Val(Substr(aCPF, 11, 1)) = aDigito2
    aValido := .T.
  End

  Return aValido
End
