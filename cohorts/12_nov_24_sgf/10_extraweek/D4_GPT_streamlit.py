# Tutorial available on Streamlit:
# https://docs.streamlit.io/develop/tutorials/llms/build-conversational-apps
from openai import OpenAI
import streamlit as st
from config import OPEN_API_KEY

st.title("ChatGPT-like clone")

client = OpenAI(api_key=OPEN_API_KEY)

# Set up default variables using the session_state
if "openai_model" not in st.session_state:
    st.session_state["openai_model"] = "gpt-3.5-turbo"

if "messages" not in st.session_state:
    st.session_state.messages = []

if prompt := st.chat_input("What is up?"):

    # Save messages previously sent
    st.session_state.messages.append({"role": "user", "content": prompt})

    # Show the user prompt
    with st.chat_message("user"):
        st.markdown(prompt)

    # Retrieve the assistant response
    with st.chat_message("assistant"):
        stream = client.chat.completions.create(
            model=st.session_state["openai_model"],
            messages=[
                {"role": m["role"], "content": m["content"]}
                for m in st.session_state.messages
            ],
            stream=True,
        )
        response = st.write_stream(stream)

    # Update chat history
    st.session_state.messages.append({"role": "assistant", "content": response})