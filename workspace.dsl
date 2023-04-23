workspace "Datamine Group" "Datamine Research System's Software Achitecture" {

  model {

    public = person "General User" "Views published reports" "Person"
    researcher = person "Researcher" "Creates and publishes reports"
    school_sys_admin = person "School Sys Admin" "Manages school data"

    group "Datamine System Overview" {
      dm_research_system = softwareSystem "Datamine Research System" "Platform to view & analyse SDG Goal 4 data" {
        !docs docs
        single_page_app = container "Single-Page Application" "Display and recieve content to users" "Typescript(ReactJS)" "Web Browser" {
          signin = component "Sign-In Controller" "Allows users to sign-in/out to Datamine" "React(TBD)"
          authorizer = component "Authorization Controller" "Manages permission rights to users"
          dashboard = component "Dashboard View" "Display published reports" "React(TBD)"
          analysis_tool = component "Analysis tool" "Allow researchers to do data analysis" "React(react-jupyter-notebook)"
          data_management = component "Data Management View" "Allows schools' sys admins to manage school data" "React(TBD)"
        }
        backend = container "Backend Application" "Delivers static content and single-page apps" "Python(Django)" {
          api_app = component "API Gateway" "Manages API requests & responses" "Django REST Framework"
        }
        database = container "Database" "Distributed database for storing data from schools" "Citus(PostgreSQL)" "Database"
      }

      #  External Systems
      school_system = softwareSystem "School System" "Sends relevant school data to DDB" "Existing System"
      accounts_system = softwareSystem "Accounts Manager System" "Authenticates users via Google, Facebook & Microsoft" "Existing System"
    }

    # Relationships between people & Software Systems
    public -> single_page_app "visits datamine.com using [HTTPS]"
    researcher -> single_page_app "visits datamine.com using [HTTPS]"
    school_sys_admin -> single_page_app "visits datamine.com using [HTTPS]"
    single_page_app -> accounts_system "verifies authentication with"
    api_app -> school_system "makes API calls to [JSON/HTTPS]"

    # Relationships to/from Containers
    single_page_app -> api_app "make API requests to"
    authorizer -> api_app "makes API calls to [JSON/HTTPS]"
    api_app -> accounts_system "seeks authentication from"
    backend -> database "Reads from and writes to"
    database -> analysis_tool "sends data to"
    database -> dashboard "sends data to"
    api_app -> dashboard "sends data to [JSON/HTTPS]"
    data_management -> backend "requests data from"
  }

  views {
    systemlandscape "SystemLandscape" {
      include *
      autoLayout
    }
    systemContext dm_research_system "SystemContext" {
      include *
      autoLayout
      description "General overview of the Datamine Research System"
    }

    container dm_research_system "Containers" {
      include *
      autoLayout
    }

    component single_page_app "Components" {
      include *
      autoLayout lr
    }

    styles {
      element "Person" {
        background #08427b
        color #ffffff
        fontSize 22
        shape Person
      }
      element "Software System" {
        background #1168bd
        color #ffffff
      }
      element "Existing System" {
        background #999999
        color #ffffff
      }
      element "Container" {
        background #438dd5
        color #ffffff
      }
      element "Web Browser" {
        shape WebBrowser
      }
      element "Database" {
        shape Cylinder
      }
      element "Component" {
        background #85bbf0
        color #000000
      }
    }
  }

}