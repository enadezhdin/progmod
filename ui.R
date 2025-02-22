# this version is deployed as Ver. 1.1.0.
library(shiny)

load("www/MPNmultistate.RData", envir=globalenv()) #need to load this data in ui part (only for docker version). Locally works w/o it.

# Define UI for dataset viewer application
fluidPage( #theme = "bootstrap.min.css",
#tags$head(tags$script(src = "message-handler.js")),  #to avoid an error in online app, since 'message-handler.js' is not present the string is commented out
tags$title("MPN Personalised Risk Calculator"),

  # Application title.
tags$h4("MPN Personalised Risk Calculator"),


br(),
  sidebarLayout(
    sidebarPanel(
#Select diagnosis - used either for preselected data, or user's own data
      selectInput("dataset", h4("Please select initial Diagnosis:"),
                  choices = c("Essential Thrombocytosis (n=1244)", "Polycythemia Vera (n=312)", "Primary/Secondary Myelofibrosis (n=276)","Other MPN (n=43)")),


selectInput("newdata",label=h4("Use existing or new patient data"),choices=c("Use existing patient data","Input new patient data","Input data from file")),

conditionalPanel(condition = 'input.newdata=="Use existing patient data"',
  wellPanel(
      selectizeInput("patient", h4("  Select Patient:"),
                  choices = dput(MPNinput$id[which(MPNinput$ET==1)]),options=list(maxOptions=2000)  )
)),
      
      ##Input own data
conditionalPanel(condition = 'input.newdata=="Input new patient data"',
  wellPanel(
style = "overflow-y:scroll; max-height: 360px",
h4("Input New Patient Data"),
helpText("Enter data for new patient.
      Unknown data will be imputed from available variables."),

textInput("UID",
          label = h6 ("Patient ID"),
          value = NA),
numericInput("Age", 
       label = h6("Age at diagnosis"), 
       value = NA),
numericInput("Hb", 
       label = h6("Haemoglobin (g/l)"), 
       value = NA),
numericInput("WCC", 
       label = h6("White cell count (x10^9/l)"), 
       value = NA),
numericInput("Pl", 
       label = h6("Platelet count (x10^9/l)"), 
       value = NA),
 fluidRow(
column(3,offset=0.5,radioButtons("Sex", label = h6("Gender"),
       choices = list("Female" = 1, "Male" = 2,
                       "Unknown" = NA), selected = "NA")), 
column(3,offset=0.5,radioButtons("PriorThrom", label = h6("Prior thrombosis"),
       choices = list("No" = 0, "Yes" = 1,
                       "Unknown" = NA),selected = "NA")),
column(3,offset=0.5,radioButtons("Splen", label = h6("Splenomegaly"),
       choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA"))
),
      fluidRow(
	column(4, offset=1,radioButtons("JAK2", label = h6("JAK2V617F"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA")),
      	column(4,offset=1,radioButtons("MPL", label = h6("MPL"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA")),
      	column(4,offset=1,radioButtons("CALR", label = h6("CALR"),
        choices = list("Type 1" = 1, "Type 2" = 2, "Absent" = 0,
                       "Unknown" = NA),selected = "NA")),
      	column(4,offset=1,radioButtons("JAK2e12", label = h6("JAK2 exon 12"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA"))
	),
      fluidRow(
	column(3,radioButtons("ASXL1", label = h6("ASXL1"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA")),
      	column(3,offset=0.2,radioButtons("TET2", label = h6("TET2"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA")),
      	column(3,offset=0.2,radioButtons("SRSF2", label = h6("SRSF2"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA")),
      	column(3,offset=0.2,radioButtons("TP53", label = h6("TP53"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA"))
	),
      fluidRow(
	column(3,radioButtons("DNMT3A", label = h6("DNMT3A"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA")),
      	column(3,offset=0.2,radioButtons("EZH2", label = h6("EZH2"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA")),
      	column(3,offset=0.2,radioButtons("U2AF1", label = h6("U2AF1"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA")),
      	column(3,offset=0.2,radioButtons("SF3B1", label = h6("SF3B1"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA"))
	),

      fluidRow(
	column(3,radioButtons("CBL", label = h6("CBL"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA")),
      	column(3,offset=0.2,radioButtons("NF1", label = h6("NF1"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA")),
      	column(3,offset=0.2,radioButtons("IDH2", label = h6("IDH2"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA")),
      	column(3,offset=0.2,radioButtons("PPM1D", label = h6("PPM1D"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA"))
	),
      fluidRow(
	column(3,radioButtons("NFE2", label = h6("NFE2"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA")),
      	column(3,offset=0.2,radioButtons("ZRSR2", label = h6("ZRSR2"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA")),
      	column(3,offset=0.2,radioButtons("NRAS", label = h6("NRAS"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA")),
      	column(3,offset=0.2,radioButtons("GNAS", label = h6("GNAS"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA"))
	),

      fluidRow(
	column(3,radioButtons("SH2B3", label = h6("SH2B3"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA")),
      	column(3,offset=0.2,radioButtons("KRAS", label = h6("KRAS"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA")),
      	column(3,offset=0.2,radioButtons("PTPN11", label = h6("PTPN11"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA")),
      	column(3,offset=0.2,radioButtons("CUX1", label = h6("CUX1"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA"))
	),
      fluidRow(
	column(3,radioButtons("SETBP1", label = h6("SETBP1"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA")),
      	column(3,offset=0.2,radioButtons("KIT", label = h6("KIT"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA")),
      	column(3,offset=0.2,radioButtons("BCOR", label = h6("BCOR"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA")),
      	column(3,offset=0.2,radioButtons("IDH1", label = h6("IDH1"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA"))
	),
      fluidRow(
	column(3,radioButtons("RUNX1", label = h6("RUNX1"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA")),
      	column(3,offset=0.2,radioButtons("GATA2", label = h6("GATA2"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA")),
      	column(3,offset=0.2,radioButtons("PHF6", label = h6("PHF6"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA")),
      	column(3,offset=0.2,radioButtons("FLT3", label = h6("FLT3"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA"))
	),

      fluidRow(
      	column(3,radioButtons("MLL3", label = h6("MLL3"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA")),
      	column(3,offset=0.2,radioButtons("GNB1", label = h6("GNB1"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA")),
      	column(3,offset=0.2,radioButtons("STAG2", label = h6("STAG2"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA")),
      	column(3,offset=0.2,radioButtons("MBD1", label = h6("MBD1"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA"))
	),


      fluidRow(                                                                  ## RB1 added to the selection list
        column(3,radioButtons("RB1", label = h6("RB1"),
                        choices = list("Present" = 1, "Absent" = 0,
                                       "Unknown" = NA),selected = "NA"))#

  ),


      fluidRow(
	column(3,radioButtons("C9U", label = h6("9pUPD"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA")),
      	column(3,offset=0.2,radioButtons("C9g", label = h6("Tri 9"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA")),
      	column(3,offset=0.2,radioButtons("C1p", label = h6("1pUPD"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA")),
      	column(3,offset=0.2,radioButtons("C1q", label = h6("1q+"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA"))
	),
      fluidRow(
	column(3,radioButtons("C4", label = h6("4qUPD"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA")),
      	column(3,offset=0.2,radioButtons("C5", label = h6("5q-"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA")),
      	column(3,offset=0.2,radioButtons("C7", label = h6("7q-"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA")),
      	column(3,offset=0.2,radioButtons("C8", label = h6("Tri 8"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA"))
	),
      fluidRow(
	column(3,radioButtons("C11", label = h6("11q-"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA")),
      	column(3,offset=0.2,radioButtons("C12", label = h6("12pUPD"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA")),
      	column(3,offset=0.2,radioButtons("C13", label = h6("13qUPD"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA")),
      	column(3,offset=0.2,radioButtons("C14", label = h6("14qUPD"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA"))
	),
      fluidRow(
	column(3,radioButtons("C17", label = h6("17p"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA")),
      	column(3,offset=0.2,radioButtons("C18", label = h6("18qUPD"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA")),
      	column(3,offset=0.2,radioButtons("C19", label = h6("19pUPD"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA")),
      	column(3,offset=0.2,radioButtons("C20", label = h6("20q-"),
        choices = list("Present" = 1, "Absent" = 0,
                       "Unknown" = NA),selected = "NA"))
	)

)
),

conditionalPanel(condition = 'input.newdata=="Input data from file"',
  wellPanel(
h3("Input New Patient Data From File"),
style = "overflow-y:scroll; max-height: 360px",
helpText("Download data template (.csv file)"),
downloadButton('downloadData', 'Download Template'),
fileInput('file1', 'Upload completed data file',
accept=c('text/csv', 'text/comma-separated-values,text/plain','.csv')),
helpText("Complete template using 0/1 for absence/presence. Age in years, Haemoglobin in g/l, white cell and platelet counts x10^9/l, 1 for female, 2 for male"),
helpText("For unknown variables: leave as NA and this will be imputed")
)),

br(),      
actionButton("update", "Calculate Risk from Selected Variables")
    ),

    mainPanel(
tabsetPanel(
tabPanel("Patient Prediction",
conditionalPanel(condition = 'input.newdata=="Use existing patient data"',
wellPanel(
style = "overflow-y:scroll; padding:10px; max-height: 200px",
h5("Patient Description",align="centre"),
textOutput("UPN"),
textOutput("MutationDesc"),
textOutput("Demographics")
)),
           
fluidRow(     
  column(9,style="padding:0px", plotOutput("msplot")), 
  column(3, style="padding:3px", img (src="Legend_key_new.png", height = 330, width = 125)) #image has to be in /www, but the path without www!
  ),
           

        
conditionalPanel(condition = 'input.newdata=="Use existing patient data"',
wellPanel(
h5("Patient Outcomes",align="centre"),
    textOutput("OutcomeMF"),
    textOutput("Outcome")
                              
)),
           
wellPanel(style = "padding:20px; max-height: 150px",         
    fluidRow(
          column(3, offset = 0,
           radioButtons(inputId="report_format", label = h5("Select report format"),
                         choices = list("HTML" = 'html_document', "Presentation" = 'powerpoint_presentation'), selected = 'html_document')),
           column (3, offset = 0,
              downloadButton("report", "Generate report")#
             )#
)
)
),
  
tabPanel("Genomics",
h4("Frequency of genomic variables across MPN phenotypes"),
fluidRow(
column(6,selectInput("Gene1", h5("Gene 1:"),
                  choices = c("JAK2","CALR","MPL","JAK2e12","TET2","ASXL1","DNMT3A","PPM1D","EZH2","NF1","NFE2","SF3B1","SRSF2","TP53","U2AF1","CBL","MLL3","ZRSR2","GNAS","KRAS","SH2B3","IDH2","PTPN11","KIT","RB1","SETBP1","BCOR","NRAS","CUX1","STAG2","IDH1","FLT3","RUNX1","PHF6","GATA2","MBD1","GNB1","Chr1p","Chr1q","Chr4","Chr5","Chr7","Chr8","Chr9p","Chr9","Chr11","Chr12","Chr13","Chr14","Chr17","Chr18","Chr19","Chr20"))),
column(6,selectInput("Gene2", h5("Gene 2:"),
                  choices = c("JAK2","CALR","MPL","JAK2e12","TET2","ASXL1","DNMT3A","PPM1D","EZH2","NF1","NFE2","SF3B1","SRSF2","TP53","U2AF1","CBL","MLL3","ZRSR2","GNAS","KRAS","SH2B3","IDH2","PTPN11","KIT","RB1","SETBP1","BCOR","NRAS","CUX1","STAG2","IDH1","FLT3","RUNX1","PHF6","GATA2","MBD1","GNB1","Chr1p","Chr1q","Chr4","Chr5","Chr7","Chr8","Chr9p","Chr9","Chr11","Chr12","Chr13","Chr14","Chr17","Chr18","Chr19","Chr20")))),

fluidRow(
column(6,textOutput("Gene1stat1")),column(6,textOutput("Gene2stat1"))),
fluidRow(
column(6,textOutput("Gene1stat2")),column(6,textOutput("Gene2stat2"))),
fluidRow(
column(6,textOutput("Gene1stat3")),column(6,textOutput("Gene2stat3"))),

fluidRow(
  column(7,offset=2,
    plotOutput('comboplot')))

),

tabPanel("Help/Comments",
         includeHTML("www/help.html")
)


     ))), 

##### added embedding for piwik javascript

HTML('<script src="/zxtm/piwik2.js"></script>')

)


