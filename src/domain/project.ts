import { Service } from "./service";
import { Project, Skill } from "./types";

interface ProjectHasSkill {
    projectId: number;
    skillId: number;
    skill?: Skill | null;
}

interface OrganizationSummary {
    id: number;
    name: string;
}

interface ProjectDTO extends Project {
    project_has_skill?: ProjectHasSkill[];
    organization?: OrganizationSummary | null;
    skills: Skill[];
}

export class ProjectService extends Service<Project> {
    private skills(project: ProjectDTO){
        const relations = project.project_has_skill ?? [];
        return relations
            .map(ps => ps.skill)
            .filter((skill): skill is Skill => skill !== null);
    }

    async getAll(): Promise<ProjectDTO[]> {
        const projects = (await this.repository.getAll({
            organization: true,
            project_has_skill: {
                include: {
                    skill: true
                }
            }
        })) as ProjectDTO[];

        return projects.map((project) => ({
            ...project,
            skills: this.skills(project),
        }));
    }

    async addSkill(projectId: number, skill: Skill): Promise<void> {
        const project = await this.repository.findById(projectId, {
            include: {
                project_has_skill: {
                    include: {
                        skill: true
                    }
                }
            }
        }) as ProjectDTO;

        if (!project) throw new Error("Project not found");

        project.skills = this.skills(project);
        const existingSkills = project.skills ?? [];
        const skillExists = existingSkills.some(
            (ps: Skill) => ps.id === skill.id
        );

        if (!skillExists) {
            await this.repository.update(projectId, {
                project_has_skill: {
                    create: {
                        skill: {
                            connect: { id: skill.id }
                        }
                    }
                }
            });
        }
    }

}