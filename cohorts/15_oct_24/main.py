import pandas as pd
pd.DataFrame.iteritems = pd.DataFrame.items
import numpy as np
import plotly.express as px
import streamlit as st
import pickle
# from streamlit_extras.add_vertical_space import add_vertical_space

### Default best practice structure when you have multiple cols:
# Define streamlit_element
# streamlit_element = st.columns, st.sidebar, st.tabs, etc. (see Layouts & Containers in docs)
# with streamlit_element:
    # Write some functions here that define what's inside
    # plotly_fig = px.line(data, x='col1', y='col2')
    # st.plotly_chart(plotly_fig)
    # st.markdown("Some markdown formatted text.")



# Plotly Syntax
# Charts
# px.histogram - for barplots and histogram
# px.scatter - for scatterplots
# px.line - for line plots
# px.pie - for pie charts

# Arguments
# data - first variable
# x - x-axis variable
# y - y-axis variable
# color - variable shown by color
# facet_row - variable to split into rows by
# facet_col - variable to split into columns by

### Goal for today: Build and deploy an EDA and ML tool
st.header("Customer Churn Analysis")
# Elements we need: data to analyze, some interesting charts, and some model
data = pd.read_csv("https://raw.githubusercontent.com/sabinagio/data-analytics/main/data/customer_churn.csv").dropna()
st.write("This is our client data:")
data.SeniorCitizen = data.SeniorCitizen.astype(bool)
col = st.selectbox("", data.columns.drop("customerID"), index=len(data.columns)-2)
if col in data.select_dtypes('number').columns:
    fig = px.histogram(data, x=col)
else:
    fig = px.histogram(data, y=col)
fig.update_layout(template="simple_white", width=600, height=600)
st.plotly_chart(fig)

st.markdown("### Exploratory Data Analysis")
st.write("Dropwdown - option 1, no space")
col1, col2 = st.columns(2)
with col1:
    charges = st.selectbox("", ("MonthlyCharges", "TotalCharges"))
with col2:
    cat_var = st.selectbox("", data.select_dtypes("object").columns.drop("customerID"))

st.write("Dropwdown - option 2, with space")
row0_spacer1, row0_1, row0_spacer2, row0_2, row0_spacer3 = st.columns(
    (0.01, 2.5, 0.1, 2.5, 0.01)
)
with row0_1:
    charges = st.selectbox("", ("MonthlyCharges", "TotalCharges"), key="charges2")
with row0_2:
    cat_var = st.selectbox("", data.select_dtypes("object").columns.drop("customerID"), key="catvar2")

fig = px.histogram(data, x=charges, facet_row=cat_var)
fig.for_each_annotation(lambda a: a.update(text=a.text.split("=")[-1]))
st.plotly_chart(fig)

st.sidebar.title("Input Parameters")
features = {}

# st.sidebar.selectbox("gender", ("Male", "Female"))
for col in data.select_dtypes(bool).columns:
    features[col] = st.sidebar.checkbox(f"Is {col}?")

for col in data.select_dtypes(object).columns.drop(['customerID', 'Churn']):
    features[col] = st.sidebar.selectbox(col, data[col].unique())

for col in data.select_dtypes('number').columns:
    features[col] = st.sidebar.slider(col, min_value=data[col].min(), max_value=data[col].max())


st.markdown("### Predict Customer Churn")
# st.write(pd.DataFrame([features]))
features_df = pd.DataFrame([features])
features_df['SeniorCitizen'] = features_df['SeniorCitizen'].astype(int)
features_df_num = features_df.select_dtypes('number')
features_df_cat = features_df.select_dtypes(object)
features_df_cat_encoded = pd.get_dummies(features_df_cat)

# st.write(features_df_cat_encoded.T)
# st.write(pd.get_dummies(data.drop("customerID", axis=1).select_dtypes(object)).T)

scaler = pickle.load(open("prep/scaler.pkl", "rb"))
features_df_num_scaled = pd.DataFrame(scaler.transform(features_df_num), columns=scaler.feature_names_in_)

# st.write(features_df_cat.columns)

log_model = pickle.load(open("models/log_reg.pkl", "rb"))
knn_model = pickle.load(open("models/knn.pkl", "rb"))
nb_model = pickle.load(open("models/bayes.pkl", "rb"))

model = st.selectbox("Select a model to use", ("Logistic Regression", "KNN", "Naive Bayes"))

def add_categorical_features(pred_df, model_features, num_features):
    model_df = pred_df.copy()
    for feature_name in model_features:
        if feature_name not in num_features:
            if feature_name not in pred_df.columns:
                model_df[feature_name] = False
    return model_df[model_features]

pred_df = pd.concat([features_df_num_scaled, features_df_cat_encoded], axis=1)
button = st.button("Predict Customer Churn")

if model == "Logistic Regression":
    feature_names = log_model.feature_names_in_
    pred_df = add_categorical_features(pred_df, model_features=feature_names, num_features=features_df_num_scaled.columns)
    
    if button:
        pred_result = log_model.predict(pred_df)
        st.write(f"Did the customer churn? {pred_result[0]}")

if model == "KNN":
    feature_names = knn_model.feature_names_in_
    pred_df = add_categorical_features(pred_df, model_features=feature_names, num_features=features_df_num_scaled.columns)
    if button:
        pred_result = knn_model.predict(pred_df)
        st.write(f"Did the customer churn? {pred_result[0]}")

if model == "Naive Bayes":
    feature_names = nb_model.feature_names_in_
    pred_df = add_categorical_features(pred_df, model_features=feature_names, num_features=features_df_num_scaled.columns)
    if button:
        pred_result = nb_model.predict(pred_df)
        st.write(f"Did the customer churn? {pred_result[0]}")



