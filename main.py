import time
from OmniGen import OmniGenPipeline
import random
import datetime
pipe = OmniGenPipeline.from_pretrained("Shitao/OmniGen-v1")

while True:
    seed=random.randint(0, 99999)
    images = pipe(
        prompt= "a high tree and a cat",
        #input_images=["example_x2024-11-18 15:58:19.457642.png"],
        height=1024, 
        width=1024,
        guidance_scale=2.5, 
        img_guidance_scale=1.6,
        max_input_image_size=1024,
        separate_cfg_infer=True, 
        use_kv_cache=True,
        offload_kv_cache=True,
        offload_model=False,
        use_input_image_size_as_output=False,
        seed=seed,
    )
    images[0].save("/omnigen/outputs/IMG_"+str(datetime.datetime.now().timestamp())+"_"+str(seed)+".png")  # save output PIL image
    time.sleep(5)

