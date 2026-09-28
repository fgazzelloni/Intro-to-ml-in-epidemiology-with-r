# ============================================================
# Machine Learning from Scratch
# Interactive Gradient Descent Demonstration
#
# R-Ladies Rome
# Introduction to Machine Learning in Epidemiology with R
# ============================================================


# ------------------------------------------------------------
# 1. Packages
# ------------------------------------------------------------

library(shiny)
library(ggplot2)


# ------------------------------------------------------------
# 2. Example data
# ------------------------------------------------------------

x <- c(1, 2, 3, 4, 5, 6, 7, 8)

y <- c(
  2.9, 3.4, 4.9, 4.7,
  6.2, 6.9, 7.3, 8.6
)

data <- data.frame(x, y)


# ------------------------------------------------------------
# 3. Gradient descent
# ------------------------------------------------------------

# Starting parameters

w <- 0
b <- 0

# Hyperparameters

learning_rate <- 0.01
epochs <- 1000


# ------------------------------------------------------------
# 4. Objects for storing the learning history
# ------------------------------------------------------------

w_history <- numeric(epochs + 1)
b_history <- numeric(epochs + 1)
loss_history <- numeric(epochs + 1)


# Initial model: epoch 0

w_history[1] <- w
b_history[1] <- b

initial_prediction <- w * x + b

loss_history[1] <- mean(
  (initial_prediction - y)^2
)


# ------------------------------------------------------------
# 5. Train the model
# ------------------------------------------------------------

for (epoch in 1:epochs) {

  # ----------------------------------
  # STEP 1: Make predictions
  # ----------------------------------

  prediction <- w * x + b


  # ----------------------------------
  # STEP 2: Calculate errors
  # ----------------------------------

  error <- prediction - y


  # ----------------------------------
  # STEP 3: Calculate gradients
  # ----------------------------------

  dw <- mean(
    2 * error * x
  )

  db <- mean(
    2 * error
  )


  # ----------------------------------
  # STEP 4: Gradient descent
  #
  # Move in the opposite direction
  # of the gradient
  # ----------------------------------

  w <- w - learning_rate * dw

  b <- b - learning_rate * db


  # ----------------------------------
  # STEP 5: Calculate new loss
  # ----------------------------------

  new_prediction <- w * x + b

  mse <- mean(
    (new_prediction - y)^2
  )


  # ----------------------------------
  # STEP 6: Store what was learned
  # ----------------------------------

  w_history[epoch + 1] <- w
  b_history[epoch + 1] <- b
  loss_history[epoch + 1] <- mse
}


# ------------------------------------------------------------
# 6. Complete learning history
# ------------------------------------------------------------

learning_history <- data.frame(

  epoch = 0:epochs,

  slope = w_history,

  intercept = b_history,

  loss = loss_history
)


# ------------------------------------------------------------
# 7. Compare with R's lm()
# ------------------------------------------------------------

lm_model <- lm(y ~ x, data = data)

lm_intercept <- coef(lm_model)[1]
lm_slope <- coef(lm_model)[2]


# ============================================================
# USER INTERFACE
# ============================================================

ui <- fluidPage(

  titlePanel(
    "How Does a Machine Learn?"
  ),


  # ----------------------------------------------------------
  # Introduction
  # ----------------------------------------------------------

  fluidRow(

    column(
      width = 12,

      h3("Linear Regression from Scratch"),

      p(
        "We start with the model:"
      ),

      tags$div(
        style = "
          font-size: 26px;
          text-align: center;
          margin: 20px;
        ",

        HTML(
          "ŷ = wx + b"
        )
      ),

      p(
        "where w is the slope and b is the intercept."
      ),

      p(
        "The goal is to find values of w and b that make
         the predictions as close as possible to the
         observed values."
      )
    )
  ),


  tags$hr(),


  # ==========================================================
  # PART 1 — MANUAL OPTIMISATION
  # ==========================================================

  h2("1. Can You Find the Best Model?"),

  p(
    "Before asking the computer to learn, try adjusting the
     model yourself."
  ),

  p(
    "Move the slope and intercept. Watch what happens to the
     regression line and the Mean Squared Error."
  ),


  sidebarLayout(

    sidebarPanel(

      sliderInput(
        "manual_w",
        "Slope (w)",
        min = -1,
        max = 2,
        value = 0,
        step = 0.05
      ),

      sliderInput(
        "manual_b",
        "Intercept (b)",
        min = -2,
        max = 5,
        value = 0,
        step = 0.1
      ),

      tags$hr(),

      h4("Your model"),

      verbatimTextOutput(
        "manual_equation"
      ),

      h4("Mean Squared Error"),

      verbatimTextOutput(
        "manual_mse"
      )
    ),


    mainPanel(

      plotOutput(
        "manual_plot",
        height = "450px"
      )
    )
  ),


  tags$hr(),


  # ==========================================================
  # PART 2 — GRADIENT DESCENT
  # ==========================================================

  h2("2. Let the Machine Learn"),

  p(
    "Instead of manually searching for good values of w and b,
     gradient descent updates them automatically."
  ),

  p(
    "Move the slider through the epochs, or press Play, to
     watch the model learn."
  ),


  sliderInput(

    "epoch",

    "Training epoch",

    min = 0,
    max = epochs,
    value = 0,

    step = 1,

    animate = animationOptions(
      interval = 40,
      loop = FALSE
    )
  ),


  # ----------------------------------------------------------
  # Current model information
  # ----------------------------------------------------------

  fluidRow(

    column(

      width = 4,

      wellPanel(

        h4("Current model"),

        verbatimTextOutput(
          "current_equation"
        )
      )
    ),


    column(

      width = 4,

      wellPanel(

        h4("Current MSE"),

        verbatimTextOutput(
          "current_loss"
        )
      )
    ),


    column(

      width = 4,

      wellPanel(

        h4("Epoch"),

        verbatimTextOutput(
          "current_epoch"
        )
      )
    )
  ),


  # ----------------------------------------------------------
  # Learning plots
  # ----------------------------------------------------------

  fluidRow(

    column(

      width = 6,

      plotOutput(
        "learning_plot",
        height = "450px"
      )
    ),


    column(

      width = 6,

      plotOutput(
        "loss_plot",
        height = "450px"
      )
    )
  ),


  tags$hr(),


  # ==========================================================
  # PART 3 — FINAL COMPARISON
  # ==========================================================

  h2("3. What Did the Machine Learn?"),

  p(
    "Gradient descent started with:"
  ),

  tags$pre(
    "w = 0
b = 0"
  ),

  p(
    "and progressively adjusted both parameters to reduce
     prediction error."
  ),


  tableOutput(
    "comparison_table"
  ),


  tags$hr(),


  # ==========================================================
  # CONCEPTUAL SUMMARY
  # ==========================================================

  h2("The Learning Process"),

  tags$pre(
    "
DATA
  |
  v
MODEL
ŷ = wx + b
  |
  v
PREDICTIONS
  |
  v
ERROR
  |
  v
LOSS (MSE)
  |
  v
GRADIENT
  |
  v
GRADIENT DESCENT
  |
  v
UPDATE w AND b
  |
  +-------------> REPEAT
"
  ),

  p(
    strong("Learning"),
    "is the process through which the data determine useful
     values for the model parameters."
  ),

  p(
    strong("Gradient descent"),
    "is the optimisation algorithm used here to perform those
     parameter updates."
  ),

  p(
    "Gradient descent is therefore not the model and it is not
     a neural network. It is one way of training a model."
  )
)


# ============================================================
# SERVER
# ============================================================

server <- function(input, output, session) {


  # ==========================================================
  # PART 1 — MANUAL OPTIMISATION
  # ==========================================================


  # ----------------------------------------------------------
  # Manual predictions
  # ----------------------------------------------------------

  manual_predictions <- reactive({

    input$manual_w * x +
      input$manual_b
  })


  # ----------------------------------------------------------
  # Manual MSE
  # ----------------------------------------------------------

  manual_mse <- reactive({

    mean(
      (manual_predictions() - y)^2
    )
  })


  # ----------------------------------------------------------
  # Manual equation
  # ----------------------------------------------------------

  output$manual_equation <- renderText({

    paste0(
      "ŷ = ",
      round(input$manual_w, 2),
      "x + ",
      round(input$manual_b, 2)
    )
  })


  # ----------------------------------------------------------
  # Manual MSE display
  # ----------------------------------------------------------

  output$manual_mse <- renderText({

    round(
      manual_mse(),
      4
    )
  })


  # ----------------------------------------------------------
  # Manual model plot
  # ----------------------------------------------------------

  output$manual_plot <- renderPlot({

    ggplot(
      data,
      aes(x = x, y = y)
    ) +

      geom_point(
        size = 3
      ) +

      geom_abline(
        slope = input$manual_w,
        intercept = input$manual_b,
        linewidth = 1
      ) +

      labs(

        title = "Adjust the Model",

        subtitle = paste0(
          "ŷ = ",
          round(input$manual_w, 2),
          "x + ",
          round(input$manual_b, 2),
          "     MSE = ",
          round(manual_mse(), 4)
        ),

        x = "x",
        y = "y"
      ) +

      coord_cartesian(
        xlim = c(0, 9),
        ylim = c(0, 10)
      ) +

      theme_minimal(
        base_size = 14
      )
  })


  # ==========================================================
  # PART 2 — AUTOMATIC LEARNING
  # ==========================================================


  # ----------------------------------------------------------
  # Current state of the model
  # ----------------------------------------------------------

  current_model <- reactive({

    learning_history[
      input$epoch + 1,
    ]
  })


  # ----------------------------------------------------------
  # Current equation
  # ----------------------------------------------------------

  output$current_equation <- renderText({

    model <- current_model()

    paste0(
      "ŷ = ",
      round(model$slope, 3),
      "x + ",
      round(model$intercept, 3)
    )
  })


  # ----------------------------------------------------------
  # Current loss
  # ----------------------------------------------------------

  output$current_loss <- renderText({

    round(
      current_model()$loss,
      5
    )
  })


  # ----------------------------------------------------------
  # Current epoch
  # ----------------------------------------------------------

  output$current_epoch <- renderText({

    input$epoch
  })


  # ----------------------------------------------------------
  # Regression line during learning
  # ----------------------------------------------------------

  output$learning_plot <- renderPlot({

    model <- current_model()


    ggplot(
      data,
      aes(x = x, y = y)
    ) +

      geom_point(
        size = 3
      ) +

      geom_abline(

        slope = model$slope,

        intercept = model$intercept,

        linewidth = 1
      ) +

      labs(

        title = paste(
          "Model at Epoch",
          input$epoch
        ),

        subtitle = paste0(

          "ŷ = ",
          round(model$slope, 3),

          "x + ",
          round(model$intercept, 3),

          "     MSE = ",
          round(model$loss, 4)
        ),

        x = "x",
        y = "y"
      ) +

      coord_cartesian(
        xlim = c(0, 9),
        ylim = c(0, 10)
      ) +

      theme_minimal(
        base_size = 14
      )
  })


  # ----------------------------------------------------------
  # Learning curve
  # ----------------------------------------------------------

  output$loss_plot <- renderPlot({

    current_epoch <- input$epoch


    # History up to the selected epoch

    shown <- learning_history[
      learning_history$epoch <= current_epoch,
    ]


    ggplot(
      learning_history,
      aes(
        x = epoch,
        y = loss
      )
    ) +

      # Full trajectory shown faintly

      geom_line(
        linewidth = 0.6,
        alpha = 0.20
      ) +

      # Learning achieved so far

      geom_line(
        data = shown,
        linewidth = 1.2
      ) +

      # Current position

      geom_point(
        data = tail(shown, 1),
        size = 4
      ) +

      labs(

        title = "Learning Curve",

        subtitle = paste0(
          "Epoch ",
          current_epoch,
          " | MSE = ",
          round(
            current_model()$loss,
            4
          )
        ),

        x = "Epoch",

        y = "Mean Squared Error"
      ) +

      theme_minimal(
        base_size = 14
      )
  })


  # ==========================================================
  # PART 3 — COMPARISON WITH lm()
  # ==========================================================

  output$comparison_table <- renderTable({

    final_model <-
      learning_history[
        nrow(learning_history),
      ]


    data.frame(

      Method = c(
        "Starting model",
        "Gradient descent",
        "R lm()"
      ),

      Slope = c(
        0,
        final_model$slope,
        lm_slope
      ),

      Intercept = c(
        0,
        final_model$intercept,
        lm_intercept
      )
    )

  }, digits = 4)

}


# ============================================================
# RUN APPLICATION
# ============================================================

shinyApp(
  ui = ui,
  server = server
)
