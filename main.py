from fastapi import FastAPI
import requests
from bs4 import BeautifulSoup


app = FastAPI()

@app.get("/meta")
def get_meta():
    url = "https://img.wzstats.gg/mxr-17_version4/gunDisplayLoadouts" # Exemplo de site de meta
    headers = {'User-Agent': 'Mozilla/5.0'} # Simula um navegador real
    
    try:
        response = requests.get(url, headers=headers, timeout=10)
        soup = BeautifulSoup(response.text, 'html.parser')
        
        armas_reais = []
        # Exemplo de seletor (isso muda conforme o site, vamos testar este):
        cards = soup.select('div.weapon-card')[:10] 

        for card in cards:
            nome = card.select_one('.weapon-name').text.strip()
            # Se não acharmos imagem no site, usamos nossa técnica do slug
            nome_slug = nome.lower().replace(" ", "-")
            
            armas_reais.append({
                "nome": nome,
                "status": "META",
                "url_imagem": f"https://img.wzstats.gg/mxr-17_version4/gunDisplayLoadouts",
                "build": ["Acessório 1", "Acessório 2", "Acessório 3"]
            })

        # Se o scraper não achar nada, retorna o fake para o app não ficar vazio
        if not armas_reais:
            return {"sucesso": True, "data": [{"nome": "Erro no Scraper", "status": "Verificar Site", "url_imagem": "", "build": []}]}

        return {"sucesso": True, "data": armas_reais}

    except Exception as e:
        return {"sucesso": False, "erro": str(e)}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)