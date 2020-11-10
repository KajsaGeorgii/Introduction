Denna övning uppfyller flera specifika syften:
1. Bekanta sig med en GWAS sumstatfil, för att det är en kärndel i genetikforskning idag. 
2. Bekanta sig med hur man använder AWK, för att kunna processa filen snabbt. 
3. Bekanta sig med att strömma igenom data via unix pipes, för att kunna modularisera de manipulationer man gör, i syfte att analysprocessen bilr tydlig och att man enkelt kan byta ut de ingående modulerna i en pipeline.
 - Att strömma data betyder att man processar data del för del. Mer specifikt i detta fall så betyder det rad för rad allt eftersom att de forslas fram och processas via de olika funktionerna mellan "pipesen". 
 - Det finns många fördelar att just processa rad för rad när det är stora filer, en uppenbar är att ram-minnet annars snabbt tar slut.
4. Bekanta sig med hur man gör ett bashscript, då de ofta får utgöra översikten för en visst delmoment, och sätter ibland ihop hela pipelinen. 
 - Bash är effektivt då det är limmet man kan använda för att koppla ihop i princip vilka program som helst.
5. Bekanta sig med hur man kallar R via ett R-script från bash. Det kan vara intressant med ett histogram. För att plotta skulle jag nog använda R och ett R-script som du kan kalla direkt från terminalen, och därför lägga in som en sista rad i ditt bashscript. Det bör gå att googla "how to use Rscript from terminal" eller liknande :)
 - För att köra R från terminalen så använder man det extra program som heter Rscript, och kommer med den vanliga installationen. 


