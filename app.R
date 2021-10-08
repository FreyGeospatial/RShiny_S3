library(shiny)
library(shinydashboard)
library(leaflet)
library(aws.s3)

s3BucketName <- scan("bucketname.txt", what = "txt")
s3File <- scan("filepath.txt", what = "txt")

#list of buckets on S3
bucketlist(key = Sys.getenv("AWS_ACCESS_KEY_ID"),
           secret = Sys.getenv("AWS_SECRET_ACCESS_KEY"),
           region = Sys.getenv("AWS_DEFAULT_REGION"))

# files in the bucket
file_names <- get_bucket_df(s3BucketName)
myMap <- s3readRDS(object = file_names[file_names$Key == s3File, "Key"], bucket = s3BucketName)

ui <- dashboardPage(
    dashboardHeader(),
    dashboardSidebar(),
    dashboardBody(
        leafletOutput("mymap", height = "92vh") #this text is an ID that must match `output$var_name` below***
    )
)

server <- function(input, output, session) {
    
    output$mymap <- renderLeaflet({ #****
        myMap
    })
}

shinyApp(ui, server)