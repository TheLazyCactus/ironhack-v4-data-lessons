import requests
import re
import time
import os

import random

def get_headers():
    user_agents = [
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:92.0) Gecko/20100101 Firefox/92.0',
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36',
        'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.81 Safari/537.36',
        'Mozilla/5.0 (iPhone; CPU iPhone OS 14_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1.1 Mobile/15E148 Safari/604.1'
    ]
    return {
        'User-Agent': random.choice(user_agents),
        'Referer': 'https://duckduckgo.com/',
        'Accept-Language': 'en-US,en;q=0.9'
    }

def search_images_ddg(key, max_n=200):
    """Search for 'key' with DuckDuckGo and return unique URLs of 'max_n' images."""
    url = 'https://duckduckgo.com/'
    params = {'q': key}
    
    # Setting up a proper User-Agent
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36'
    }
    
    # Get the search token (vqd)
    res = requests.post(url, data=params, headers=get_headers())
    if res.status_code != 200:
        print(f"Failed to fetch the token. Status code: {res.status_code}")
        return
    
    searchObj = re.search(r'vqd=([\d-]+)\&', res.text)
    if not searchObj:
        print('Token Parsing Failed!')
        return
    
    vqd_token = searchObj.group(1)
    requestUrl = url + 'i.js'
    params = {
        'l': 'us-en',
        'o': 'json',
        'q': key,
        'vqd': vqd_token,
        'f': ',,,',
        'p': '1',
        'v7exp': 'a'
    }
    
    urls = set()
    while len(urls) < max_n:
        try:
            res = requests.get(requestUrl, headers=headers, params=params)
            if res.status_code != 200:
                print(f"Request failed. Status code: {res.status_code}")
                break
            
            data = res.json()
            for obj in data.get('results', []):
                urls.add(obj['image'])
                if len(urls) >= max_n:
                    break
            
            # Check if there is a next page
            if 'next' not in data:
                break
            requestUrl = url + data['next']
            
            # Adding a delay to avoid being rate-limited
            time.sleep(1)
        except Exception as e:
            print(f"An error occurred: {e}")
            break
    
    return urls


def download_images(image_urls, image_prefix="image", output_folder='downloaded_images'):
    """Download images from a list of URLs and save them to the output folder."""
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)

    for i, url in enumerate(image_urls):
        try:
            res = requests.get(url, stream=True)
            if res.status_code == 200:
                file_extension = url.split('.')[-1].split('?')[0]  # Get file extension
                file_name = os.path.join(output_folder, f'{image_prefix}_{i + 1}.{file_extension}')
                
                with open(file_name, 'wb') as file:
                    for chunk in res.iter_content(1024):
                        file.write(chunk)
                
                print(f"Downloaded: {file_name}")
            else:
                print(f"Failed to download {url} (Status code: {res.status_code})")
        except Exception as e:
            print(f"Error downloading {url}: {e}")