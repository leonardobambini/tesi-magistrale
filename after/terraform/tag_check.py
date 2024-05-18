from genericpath import exists
import json
from jsonpath_ng import jsonpath, parse

required_tags = ["Project", "Team", "Environment"]
allowed_environments = ["DEV", "INT", "PRD"]
force_tag_strategy = False



# File path
file_path = "plan.json"

# Read data from file
with open(file_path, "r") as file:
    data = json.load(file)

for obj in data["planned_values"]["root_module"]["child_modules"]:
    for subobj in obj["resources"]:
        # JSONPath query
        #jsonpath_expr = parse("$.planned_values.root_module.child_modules[].resources[][.address, .values.tags, .values.tags_all]")
        #jsonpath_expr = parse("$.planned_values.root_module.child_modules[*].resources[*]['values.tags']")
        #jsonpath_expr = parse("$.planned_values.root_module.child_modules[*].resources[*].values.tags")
        #jsonpath_expr = parse("$..['address', 'tags', 'tags_all']")
        
        jsonpath_expr_address = parse("address")
        jsonpath_expr_tags = parse("values.tags")
        #jsonpath_expr_tags_all = parse("tags_all")

        matches_expr_address = [match.value for match in jsonpath_expr_address.find(subobj)]
        matches_expr_tags = [match.value for match in jsonpath_expr_tags.find(subobj)]
        #matches_expr_tags_all = [match.value for match in jsonpath_expr_tags_all.find(subobj)]

        # Print results
        #print("For object:", subobj)
        #print("Obj: ", subobj)
        print("Tags: ", matches_expr_tags)
        #print("Tags_all: ", matches_expr_tags_all)
        print("Address: ", matches_expr_address)
        
        if matches_expr_tags:
            if matches_expr_tags[0] is not None:
                #print(matches_expr_tags[0])
                #for tag in matches_expr_tags[0]:
                    #print("key: " + tag)
                    #print("value: " + matches_expr_tags[0][tag])
                
                for required_tag in required_tags:
                    if required_tag not in matches_expr_tags[0].keys():
                        if force_tag_strategy:
                            print(f"ERROR: Required tag {required_tag} not found in resource {matches_expr_address[0]}")
                            exit(1)
                        else:
                            print(f"WARNING: Required tag {required_tag} not found in resource {matches_expr_address[0]}")
                    print(matches_expr_tags[0])
                    
                if "Environment" in matches_expr_tags[0]:
                    if matches_expr_tags[0]["Environment"] not in allowed_environments:
                        if force_tag_strategy:
                            print(f"ERROR: Required tag Environment has a value {matches_expr_tags[0]['Environment']} not allowed ({allowed_environments})")
                            exit(1)
                        else:
                            print(f"WARNING: Required tag Environment has a value {matches_expr_tags[0]['Environment']} not allowed ({allowed_environments})")

        # if matches_expr_tags is None:
        #     print("AAAAAAAAA " + matches_expr_tags[0])

        print("----------")


