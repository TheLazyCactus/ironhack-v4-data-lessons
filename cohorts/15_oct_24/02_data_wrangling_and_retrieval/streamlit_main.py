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
    
### Goal for today: Build and deploy an EDA tool
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

fig = px.histogram(data, x=charges, facet_row=cat_var)
fig.for_each_annotation(lambda a: a.update(text=a.text.split("=")[-1]))
st.plotly_chart(fig)
