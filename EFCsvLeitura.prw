#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} EFCsvLeitura
Leitura de Arquivo EXECEL extenção .CSV
@type function
@version 12.1.33
@author Endreo Figueiredo
@since 28/01/2022
@return variant, array com linhas do arquivo
/*/
User Function EFCsvLeitura()

    Local aLine := {}
    Local cFile := cGetFile( '|Execel|*.csv' , 'Escolha o arquivo', 0 , 'C:\' , .F. , GETF_LOCALHARD , .F. ) //Abe Pasta do Arquivo
    Local oFile := Nil 

    //Verifica se existe arquivo selecionado
    If File(cFile)
        //Cria objeto de arquivo
        oFile := FWFileReader():New( cFile )

        //Faz a abertuta do arquivo 
         If (oFile:Open())
            //Retorna todas as linha como array 
            aLine   := oFile:getAllLines()

            //Fecha arquivo 
            oFile:Close()
        EndIf 

    EndIf
//Retorna Array com todas as Linhas 
Return aLine




/*
    Local aItens := {}
    Para cada linha retornada voce pode quebrar a linha por colunas 

    For nX:= 1 to Len(aLine)

        aItens := StrToArray(aLine,";")

        aItens[1] //Coluna 1 
        aItens[2] //Coluna 2
    
    Next nX


      
*/
