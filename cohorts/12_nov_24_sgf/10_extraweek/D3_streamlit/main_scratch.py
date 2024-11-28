import pandas as pd
pd.DataFrame.iteritems = pd.DataFrame.items
import numpy as np
import plotly.express as px
import streamlit as st
import pickle
# from streamlit_extras.add_vertical_space import add_vertical_space

# Plotly Syntax
# Charts
# px.histogram - for barplots and histogram
# px.scatter - for scatterplots
# px.line - for line plots
# px.pie - for pie charts
# px.box - for boxplots

# Arguments
# data - first variable
# x - x-axis variable
# y - y-axis variable
# color - variable shown by color
# facet_row - variable to split into rows by
# facet_col - variable to split into columns by

st.set_page_config(layout="wide")
st.header("Customer Churn Analysis")
st.markdown("#### Exploratory Data Analysis")

data = pd.read_csv("https://raw.githubusercontent.com/sabinagio/data-analytics/main/data/customer_churn.csv")
data.drop(columns=['customerID'], inplace=True)
st.write(data)

data["SeniorCitizen"] = data["SeniorCitizen"].astype(bool)
num_cols = data.select_dtypes('number').columns
col1, col2 = st.columns(2)

with col1:
    selection = st.selectbox("", data.columns, key="variable1")
    if selection in num_cols:
        st.plotly_chart(px.histogram(data, x=selection))
    else:
        st.plotly_chart(px.histogram(data, y=selection))

with col2:
    selection2 = st.selectbox("", data.columns, key="variable2")
    if selection in num_cols and selection2 in num_cols:
        st.plotly_chart(px.scatter(data, x=selection, y=selection2))
    elif selection in num_cols:
        st.plotly_chart(px.histogram(data, x=selection, facet_row=selection2))
    elif selection2 in num_cols:
        st.plotly_chart(px.histogram(data, x=selection2, facet_row=selection))
    else:
        st.plotly_chart(px.histogram(data, x=selection, color=selection2, barmode="group"))

# Create sidebar
st.sidebar.title("Input Parameters")
# st.sidebar.write(data.head())
# gender = st.sidebar.selectbox("Gender", data.gender.unique())
# senior = st.sidebar.checkbox("Is SeniorCitizen?")
# total_charges = st.sidebar.slider("TotalCharges", min_value=0, max_value=5000, step=100)
# features = {}

features = {}
for col in data.columns.drop("Churn"):
    if col in num_cols:
        features[col] = st.sidebar.slider(col, min_value=0, max_value=int(data[col].max()))
    elif col in data.select_dtypes(bool).columns:
        features[col] = st.sidebar.checkbox(col)
    else:
        features[col] = st.sidebar.selectbox(col, data[col].unique())

st.markdown("### Predict Customer Churn")

# Collect data about current client and add in a df
st.write(features)
features_df = pd.DataFrame([features])
st.write(features_df)
features_df['SeniorCitizen'] = features_df['SeniorCitizen'].astype(int)

# Separating between numerical and categorical variables
features_df_num = features_df.select_dtypes('number')
features_df_cat = features_df.select_dtypes(object)

# Loading scaler and encoder already "trained"
scaler = pickle.load(open("prep/scaler.pkl", "rb"))
encoder = pickle.load(open("prep/encoder.pkl", "rb"))

# Scaling and encoding new data
features_df_cat_encoded = pd.DataFrame(
    encoder.transform(features_df_cat).todense(),
    columns=encoder.get_feature_names_out()
)
features_df_num_encoded = pd.DataFrame(
    scaler.transform(features_df_num),
    columns=scaler.get_feature_names_out()
)
features_df_prep = pd.concat([features_df_cat_encoded, features_df_num_encoded], axis=1)
st.write(features_df_prep)

button = st.button("Predict Customer Churn")

# Load model
model = pickle.load(open("models/log_reg.pkl", "rb"))
knn = pickle.load(open("models/knn.pkl", "rb"))
nb = pickle.load(open("models/bayes.pkl", "rb"))

st.selectbox("Model", ["Logistic Regression", "KNN", "Naive Bayes"])
if model == "Logistic Regression":
    feature_names = model.feature_names_in_
    
    if button:
        pred_result = model.predict(features_df_prep[feature_names])
        st.write(f"Did the customer churn? {pred_result[0]}")

if model == "KNN":
    feature_names = knn.feature_names_in_

    if button:
        pred_result = knn.predict(features_df_prep[feature_names])
        st.write(f"Did the customer churn? {pred_result[0]}")

if model == "Naive Bayes":
    feature_names = nb.feature_names_in_
    if button:
        pred_result = nb.predict(features_df_prep[feature_names])
        st.write(f"Did the customer churn? {pred_result[0]}")

if button:
    st.write(model.predict(features_df_prep[model.feature_names_in_])[0])
