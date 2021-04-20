import json
def load_defaults(uid):
    eco_git_path = "https://raw.githubusercontent.com/EconomicsObservatory/ECOvisualisations/main/articles/"+uid+"/data/"
    vega_embed = open("../../guidelines/html/vega-embed.html", "r").read()
    colors = json.loads(open("../../guidelines/colors/eco-colors.json", "r").read())
    category_color = json.loads(
        open("../../guidelines/colors/eco-category-color.json", "r").read()
    )
    hue_color = json.loads(
        open("../../guidelines/colors/eco-single-hue-color.json", "r").read()
    )
    mhue_color = json.loads(
        open("../../guidelines/colors/eco-multi-hue-color.json", "r").read()
    )
    div_color = json.loads(
        open("../../guidelines/colors/eco-diverging-color.json", "r").read()
    )
    config = json.loads(open("../../guidelines/charts/eco-global-config.json", "r").read())
    return (eco_git_path,vega_embed,colors,{'category':category_color,'single-hue':hue_color,'multi-hue':mhue_color,'div-color':div_color},config)

def save_csv_html(df,f,eco_git_path,vega_embed):
    f1 = eco_git_path + f + ".csv"
    print('Saving CSV...')
    df.to_csv("data/" + f + ".csv")
    print('Saving HTML...')
    open("visualisation/" + f + ".html", "w").write(
        vega_embed.replace(
            "JSON_PATH", f1.replace("/data/", "/visualisation/").replace(".csv", ".json")
        )
    )
    print('GitHub path: ',f1)
    return f